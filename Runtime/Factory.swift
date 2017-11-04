//
//  Factory.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


public func build<T>() throws -> T {
    if let value = try build(type: T.self) as? T {
        return value
    }
    
    throw RuntimeError.couldNotCastValue
}

public func build(type: Any.Type) throws -> Any {
    
    if let defaultConstructor = type as? DefaultConstructor.Type {
        return defaultConstructor.init()
    }
    
    let kind = Kind(type: type)
    
    switch kind {
    case .struct:
        return try buildStruct(type: type)
    case .class:
        return try buildClass(type: type)
    default:
        throw RuntimeError.unableToBuildType
    }
}

func buildStruct(type: Any.Type) throws -> Any {
    let info = try typeInfo(of: type)
    let pointer = UnsafeMutableRawPointer.allocate(bytes: info.size, alignedTo: info.alignment)
    defer { pointer.deallocate(bytes: info.size, alignedTo: info.alignment) }
    try setProperties(typeInfo: info, pointer: pointer)
    return getters(type: type).get(from: pointer)
}

func buildClass(type: Any.Type) throws -> Any {
    let info = try typeInfo(of: type)
    if let type = type as? AnyClass, var value = class_createInstance(type, 0) {
        try withClassValuePointer(of: &value) { pointer in
            try setProperties(typeInfo: info, pointer: pointer)
        }
        return value
    }
    throw RuntimeError.unableToBuildType
}


func setProperties(typeInfo: TypeInfo, pointer: UnsafeMutableRawPointer) throws {
    for property in typeInfo.properties {
        let value = try getDefaultValue(for: property.type)
        let valuePointer = pointer.advanced(by: property.offset)
        let sets = setters(type: property.type)
        sets.set(value: value, pointer: valuePointer)
    }
}


func getDefaultValue(for type: Any.Type) throws -> Any {
    
    if let constructable = type as? DefaultConstructor.Type {
        return constructable.init()
    } else if let isOptional = type as? ExpressibleByNilLiteral.Type {
        return isOptional.init(nilLiteral: ())
    }
    
    return try build(type: type)
}
