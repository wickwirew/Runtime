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

/// https://github.com/apple/swift/blob/f2c42509628bed66bf5b8ee02fae778a2ba747a1/include/swift/Reflection/Records.h#L160
struct FieldDescriptor {
    
    var mangledTypeNameOffset: Int32
    var superClassOffset: Int32
    var _kind: UInt16
    var fieldRecordSize: Int16
    var numFields: Int32
    var fields: Vector<FieldRecord>
    
    var kind: FieldDescriptorKind {
        return FieldDescriptorKind(rawValue: _kind)!
    }
}

struct FieldRecord {
    
    var fieldRecordFlags: Int32
    var _mangledTypeName: RelativePointer<Int32, Int8>
    var _fieldName: RelativePointer<Int32, UInt8>
    
    var isVar: Bool {
        return (fieldRecordFlags & 0x2) == 0x2
    }
    
    mutating func fieldName() -> String {
        return String(cString: _fieldName.advanced())
    }
    
    mutating func mangedTypeName() -> String {
        return String(cString: _mangledTypeName.advanced())
    }
    
    mutating func type(genericContext: UnsafeRawPointer?,
                       genericArguments: UnsafeRawPointer?) -> Any.Type {
        let typeName = _mangledTypeName.advanced()
        let metadataPtr = swift_getTypeByMangledNameInContext(
            typeName,
            getSymbolicMangledNameLength(typeName),
            genericContext,
            genericArguments?.assumingMemoryBound(to: Optional<UnsafeRawPointer>.self)
        )!
        
        return unsafeBitCast(metadataPtr, to: Any.Type.self)
    }
    
    func getSymbolicMangledNameLength(_ base: UnsafeRawPointer) -> Int32 {
        var end = base
        while let current = Optional(end.load(as: UInt8.self)), current != 0 {
            end += 1
            if current >= 0x1 && current <= 0x17 {
                end += 4
            } else if current >= 0x18 && current <= 0x1F {
                end += MemoryLayout<Int>.size
            }
        }
        
        return Int32(end - base)
    }
}

enum FieldDescriptorKind: UInt16 {
    case `struct`
    case `class`
    case `enum`
    case multiPayloadEnum
    case `protocol`
    case classProtocol
    case objcProtocol
    case objcClass
}
