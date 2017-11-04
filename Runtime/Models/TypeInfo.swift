//
//  TypeInfo.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


public struct TypeInfo {
    public let kind: Kind
    public let name: String
    public let type: Any.Type
    public let mangledName: String
    public let properties: [PropertyInfo]
    public let genericTypes: [Any.Type]
    public let numberOfProperties: Int
    public let numberOfGenericTypes: Int
    public let size: Int
    public let alignment: Int
    public let stride: Int
    
    func property(named: String) throws -> PropertyInfo {
        if let prop = properties.first(where: { $0.name == named }) {
            return prop
        }
        
        throw RuntimeError.noPropertyNamed
    }
}

public func typeInfo(of type: Any.Type) throws -> TypeInfo {
    let kind = Kind(type: type)
    
    var typeInfoConvertible: TypeInfoConvertible
    
    switch kind {
    case .struct:
        typeInfoConvertible = StructMetadata(type: type)
    case .class:
        typeInfoConvertible = ClassMetadata(type: type)
    case .protocol:
        typeInfoConvertible = ProtocolMetadata(type: type)
    default:
        throw RuntimeError.couldNotGetTypeInfo
    }
    
    return typeInfoConvertible.toTypeInfo()
}
