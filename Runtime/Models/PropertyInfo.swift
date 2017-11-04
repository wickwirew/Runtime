//
//  PropertyInfo.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


public struct PropertyInfo {
    
    public let name: String
    public let type: Any.Type
    public let offset: Int
    public let ownerType: Any.Type
    
    public func set<TObject>(value: Any, on object: inout TObject) throws {
        try withValuePointer(of: &object) { pointer in
            try set(value: value, pointer: pointer)
        }
    }
    
    public func set(value: Any, on object: inout Any) throws {
        try withValuePointer(of: &object) { pointer in
            try set(value: value, pointer: pointer)
        }
    }
    
    private func set(value: Any, pointer: UnsafeMutableRawPointer) throws {
        if Swift.type(of: value) != self.type { return }
        let valuePointer = pointer.advanced(by: offset)
        let sets = setters(type: type)
        sets.set(value: value, pointer: valuePointer)
    }
    
    public func get<TValue>(from object: Any) throws -> TValue {
        if let value = try get(from: object) as? TValue {
            return value
        }
        
        throw RuntimeError.couldNotCastValue
    }
    
    public func get(from object: Any) throws -> Any {
        var object = object
        return try withValuePointer(of: &object) { pointer in
            let valuePointer = pointer.advanced(by: offset)
            let gets = getters(type: type)
            return gets.get(from: valuePointer)
        }
    }
}
