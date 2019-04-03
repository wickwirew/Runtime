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
    
    mutating func type() -> Any.Type {
        return _getTypeByMangledNameInContext(mangedTypeName(), 256, genericContext: nil, genericArguments: nil)!
    }
}
