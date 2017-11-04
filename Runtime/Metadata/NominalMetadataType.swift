//
//  NominalMetadataType.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



protocol NominalMetadataType: MetadataType, TypeInfoConvertible {
    var nominalTypeDescriptor: UnsafeMutablePointer<NominalTypeDescriptor> { get set }
}

extension NominalMetadataType {
    
    mutating func mangledName() -> String {
        return String(cString: nominalTypeDescriptor.pointee.mangledName.advanced())
    }
    
    mutating func numberOfFields() -> Int {
        return nominalTypeDescriptor.pointee.numberOfFields.getInt()
    }
    
    mutating func fieldOffsets() -> [Int] {
        return nominalTypeDescriptor.pointee.offsetToTheFieldOffsetVector.vector(metadata: base, n: numberOfFields())
    }
    
    mutating func fieldNames() -> [String] {
        return strings(from: nominalTypeDescriptor.pointee.fieldNames.advanced(), n: numberOfFields())
    }
    
    mutating func fieldTypeAccessor() -> FieldTypeAccessor {
        let function = nominalTypeDescriptor.pointee.fieldTypeAccessor.advanced()
        return unsafeBitCast(function, to: FieldTypeAccessor.self)
    }
    
    mutating func fieldTypes() -> [Any.Type] {
        let start = fieldTypeAccessor()(base)
        let types = start.vector(n: numberOfFields())
        return types.map{ unsafeBitCast($0, to: Any.Type.self) }
    }
    
    mutating func genericParameterCount() -> Int {
        return nominalTypeDescriptor.pointee.exclusiveGenericParametersCount.getInt()
    }
    
    mutating func genericParameters() -> [Any.Type] {
        return nominalTypeDescriptor.pointee.genericParameterVector.vector(metadata: base, n: genericParameterCount())
    }
}


extension NominalMetadataType {
    
    mutating func toTypeInfo() -> TypeInfo {
        let names = fieldNames()
        let offsets = fieldOffsets()
        let types = fieldTypes()
        let num = numberOfFields()
        var properties = [PropertyInfo]()
        for i in 0..<num {
            properties.append(PropertyInfo(name: names[i], type: types[i], offset: offsets[i], ownerType: type))
        }
        return TypeInfo(
            kind: kind,
            name: "\(type)",
            type: type,
            mangledName: mangledName(),
            properties: properties,
            genericTypes: genericParameters(),
            numberOfProperties: num,
            numberOfGenericTypes: genericParameterCount(),
            size: size,
            alignment: alignment,
            stride: stride
        )
    }
}
