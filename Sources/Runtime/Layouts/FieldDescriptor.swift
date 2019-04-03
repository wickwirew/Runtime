//
//  FieldDescriptor.swift
//  Runtime
//
//  Created by Wes Wickwire on 4/2/19.
//

/// https://github.com/apple/swift/blob/f2c42509628bed66bf5b8ee02fae778a2ba747a1/include/swift/Reflection/Records.h#L160
struct FieldDescriptor {
    var mangledTypeNameOffset: Int32
    var superClassOffset: Int32
    var fieldDescriptorKind: UInt16
    var fieldRecordSize: Int16
    var numFields: Int32
    var fields: Vector<FieldRecord>
}

struct FieldRecord {
    
    var fieldRecordFlags: Int32
    var _mangledTypeName: RelativePointer<Int32, UInt8>
    var _fieldName: RelativePointer<Int32, UInt8>
    
    mutating func fieldName() -> String {
        return String(cString: _fieldName.advanced())
    }
    
    mutating func mangedTypeName() -> String {
        return String(cString: _mangledTypeName.advanced())
    }
    
    mutating func type(genericContext: UnsafeRawPointer?,
                       genericArguments: UnsafeRawPointer?) -> Any.Type {
        let typeName = _mangledTypeName.advanced()
        return _getTypeByMangledNameInContext(
            typeName,
            getSymbolicMangledNameLength(typeName),
            genericContext: genericContext,
            genericArguments: genericArguments
        )!
    }
    
    func getSymbolicMangledNameLength(_ base: UnsafeRawPointer) -> Int {
        var end = base
        while let current = Optional(end.load(as: UInt8.self)), current != 0 {
            end = end + 1
            if current >= 0x1 && current <= 0x17 {
                end += 4
            } else if current >= 0x18 && current <= 0x1F {
                end += MemoryLayout<Int>.size
            }
        }
        
        return end - base
    }
}
