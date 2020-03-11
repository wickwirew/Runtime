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

import Foundation

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
    case .struct:
        return try buildStruct(type: type, constructor: constructor)
    case .class:
        return try buildClass(type: type)
    default:
        throw RuntimeError.unableToBuildType(type: type)
    }
}

func buildStruct(type: Any.Type, constructor: ((PropertyInfo) throws -> Any)? = nil) throws -> Any {
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

func setProperties(typeInfo: TypeInfo,
                   pointer: UnsafeMutableRawPointer,
                   constructor: ((PropertyInfo) throws -> Any)? = nil) throws {
    for property in typeInfo.properties {
        let value = try constructor.map { (resolver) -> Any in
            return try resolver(property)
        } ?? defaultValue(of: property.type)
        
        let valuePointer = pointer.advanced(by: property.offset)
        let sets = setters(type: property.type)
        sets.set(value: value, pointer: valuePointer)
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
