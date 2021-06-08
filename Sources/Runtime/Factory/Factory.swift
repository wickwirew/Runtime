// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(CRuntime)
import CRuntime
#endif

public func createInstance<T>(constructor: ((PropertyInfo) throws -> Any)? = nil) throws -> T {
    if let value = try createInstance(of: T.self, constructor: constructor) as? T {
        return value
    }
    
    throw RuntimeError.unableToBuildType(type: T.self)
}

public func createInstance(of type: Any.Type, constructor: ((PropertyInfo) throws -> Any)? = nil) throws -> Any {
    
    if let defaultConstructor = type as? DefaultConstructor.Type {
        return defaultConstructor.init()
    }
    
    let kind = Kind(type: type)
    switch kind {
    case .struct, .tuple:
        return try buildStructOrTuple(type: type, constructor: constructor)
    case .class:
        return try buildClass(type: type)
    case .enum:
        return try buildEnum(type: type, caseIndex: 0)
    default:
        throw RuntimeError.unableToBuildType(type: type)
    }
}

public func allCases<T>(of type: T.Type = T.self) throws -> [T] {
    guard Kind(type: type) == .enum else {
        throw RuntimeError.unableToBuildType(type: type)
    }
    
    return try typeInfo(of: type)
        .cases
        .enumerated()
        .map(\.offset)
        .compactMap { index in
            try buildEnum(type: type, caseIndex: index) as? T
        }
}

func buildStructOrTuple(type: Any.Type, constructor: ((PropertyInfo) throws -> Any)? = nil) throws -> Any {
    let info = try typeInfo(of: type)
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: info.size, alignment: info.alignment)
    defer { pointer.deallocate() }
    try setProperties(typeInfo: info, pointer: pointer, constructor: constructor)
    return getters(type: type).get(from: pointer)
}

func buildClass(type: Any.Type) throws -> Any {
    var md = ClassMetadata(type: type)
    let info = md.toTypeInfo()
    let metadata = unsafeBitCast(type, to: UnsafeRawPointer.self)
    let instanceSize = Int32(md.pointer.pointee.classSize)
    let alignment = Int32(md.alignment)

    guard let value = swift_allocObject(metadata, instanceSize, alignment) else {
            throw RuntimeError.unableToBuildType(type: type)
    }

    try setProperties(typeInfo: info, pointer: UnsafeMutableRawPointer(mutating: value))

    return unsafeBitCast(value, to: AnyObject.self)
}

func buildEnum(type: Any.Type, caseIndex: Int) throws -> Any {
    let info = try typeInfo(of: type)
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: info.size, alignment: info.alignment)
    defer { pointer.deallocate() }
    
    func returnEnum() -> Any {
        getters(type: type).get(from: pointer)
    }
    
    // Initialize an Enum based on https://github.com/apple/swift/blob/main/docs/ABI/TypeLayout.rst#fragile-enum-layout
    
    // Empty Enums:
    if info.cases.isEmpty {
        // In the degenerate case of an enum with no cases, the enum is an empty type.
        return returnEnum()
    }
    
    guard info.cases.indices.contains(caseIndex) else {
        throw RuntimeError.unableToBuildType(type: type)
    }
    
    // Single-Case Enums
    if info.cases.count == 1, let singleCase = info.cases.first {
        guard let payloadType = singleCase.payloadType else {
            // Empty if the case has no data type.
            return returnEnum()
        }
        
        // In the degenerate case of an enum with a single case, there is no discriminator needed,
        // and the enum type has the exact same layout as its case's data type
        let value = try defaultValue(of: payloadType)
        let sets = setters(type: payloadType)
        sets.set(value: value, pointer: pointer, initialize: true)
        
        return returnEnum()
    }
    
    // C-Like Enums
    let payloadTypes = info.cases.compactMap({ $0.payloadType })
    if payloadTypes.isEmpty {
        // If none of the cases has a data type (a "C-like" enum), then the enum is laid out as an integer tag
        // with the minimal number of bits to contain all of the cases. The machine-level layout of the type
        // then follows LLVM's data layout rules for integer types on the target platform. The cases are assigned
        // tag values in declaration order.
        
        switch info.size {
            case MemoryLayout<UInt8>.size:
                guard let uInt8CaseIndex = UInt8(exactly: caseIndex) else {
                    throw RuntimeError.unableToBuildType(type: type)
                }
                pointer.storeBytes(of: uInt8CaseIndex, as: UInt8.self)
            case MemoryLayout<UInt16>.size:
                guard let uInt16CaseIndex = UInt16(exactly: caseIndex) else {
                    throw RuntimeError.unableToBuildType(type: type)
                }
                pointer.storeBytes(of: uInt16CaseIndex, as: UInt16.self)
            default:
                // Our enum would have more then 65535 cases or there is an error in our logic
                throw RuntimeError.unableToBuildType(type: type)
        }
    }
    
    // Single-Payload Enums
    if payloadTypes.count == 1,
        let singlePayloadType = payloadTypes.first,
        let singlePayloadTypeInfo = try? typeInfo(of: singlePayloadType) {
        // If an enum has a single case with a data type and one or more no-data cases (a "single-payload" enum), then
        // the case with data type is represented using the data type's binary representation, with added zero bits for
        // tag if necessary. If the data type's binary representation has extra inhabitants, that is, bit patterns with
        // the size and alignment of the type but which do not form valid values of that type, they are used to represent
        // the no-data cases, with extra inhabitants in order of ascending numeric value matching no-data cases in declaration
        // order. If the type has spare bits (see Multi-Payload Enums), they are used to form extra inhabitants. The enum value
        // is then represented as an integer with the storage size in bits of the data type. Extra inhabitants of the payload
        // type not used by the enum type become extra inhabitants of the enum type itself.
        //
        // If the data type has no extra inhabitants, or there are not enough extra inhabitants to represent all of the no-data
        // cases, then a tag bit is added to the enum's representation. The tag bit is set for the no-data cases, which are then
        // assigned values in the data area of the enum in declaration order.
        #warning("""
            I do not easily see a way to calculate the spare bits of the singlePayloadTypeInfo to determine if we can use the
            extra spare bits. Is there a way to determine this shomehow using runtime information?
        """)
        throw RuntimeError.unableToBuildType(type: type)
    }
    
    
    // Multi-Payload Enums
    if payloadTypes.count > 1 {
        // If an enum has more than one case with data type, then a tag is necessary to discriminate the data types.
        // The ABI will first try to find common spare bits, that is, bits in the data types' binary representations
        // which are either fixed-zero or ignored by valid values of all of the data types. The tag will be scattered
        // into these spare bits as much as possible. Currently only spare bits of primitive integer types, such as the
        // high bits of an i21 type, are considered. The enum data is represented as an integer with the storage size
        // in bits of the largest data type.
        
        // If there are not enough spare bits to contain the tag, then additional bits are added to the representation
        // to contain the tag. Tag values are assigned to data cases in declaration order. If there are no-data cases,
        // they are collected under a common tag, and assigned values in the data area of the enum in declaration order.
        #warning("""
            Same problem as above: We would need to max value of the spare bits of all payloadTypes to determine how the cases are
            represented in memory.
        """)
        throw RuntimeError.unableToBuildType(type: type)
    }
    
    // Encountered an unexpected enum type
    throw RuntimeError.unableToBuildType(type: type)
}

func setProperties(typeInfo: TypeInfo,
                   pointer: UnsafeMutableRawPointer,
                   constructor: ((PropertyInfo) throws -> Any)? = nil) throws {
    for property in typeInfo.properties {
        let value = try constructor.map { (resolver) -> Any in
            return try resolver(property)
        } ?? defaultValue(of: property.type)
        
        let valuePointer = pointer.advanced(by: property.offset)
        let sets = setters(type: property.type)
        sets.set(value: value, pointer: valuePointer, initialize: true)
    }
}

func defaultValue(of type: Any.Type) throws -> Any {
    
    if let constructable = type as? DefaultConstructor.Type {
        return constructable.init()
    } else if let isOptional = type as? ExpressibleByNilLiteral.Type {
        return isOptional.init(nilLiteral: ())
    }
    
    return try createInstance(of: type)
}
