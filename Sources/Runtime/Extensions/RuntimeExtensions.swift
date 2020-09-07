//
//  RuntimeExtensions.swift
//  
//  Copyright © 2020 Jason Jobe. All rights reserved.
//  Created by Jason Jobe on 9/7/20.
//

import Foundation
//import Runtime
//import CRuntime
/**
 The is a marker Protocol to indicate Types that need/should not
 be normally drilled into by the Runtime TypeInfo graph traversal.
 */
protocol SealedToRuntime {}

protocol RuntimeDictionaryType {
    static var _keyType: Any.Type    { get }
    static var _valueType: Any.Type  { get }
}

extension Dictionary: RuntimeDictionaryType {
    static var _keyType: Any.Type    { Key.self }
    static var _valueType: Any.Type  { Value.self }
}

protocol RuntimeArrayType {
    static var _elementType: Any.Type { get }
}

extension Array: RuntimeArrayType {
    static var _elementType: Any.Type { return Element.self }
}

// MARK: Sealed Types
extension Array: SealedToRuntime {}

// Runtime Testing
public extension Runtime.TypeInfo {
    var isOptional: Bool { kind == .optional }
    var elementType: Any.Type? { self.genericTypes.first }
    var isArray: Bool { self.type is RuntimeArrayType }
    
    var is_objCClassWrapper: Bool {
        properties[0].kind == .objCClassWrapper
    }
}

public extension PropertyInfo {
    var kind: Kind { Kind(type: self.type) }
    var isOptional: Bool { kind == .optional }
    
    // HACKish to check if it a low level "Foundational" type
    var sealed: Bool {
        kind == .opaque || kind == .objCClassWrapper
            || type is String.Type
            || type is SealedToRuntime.Type
    }

    func description() -> String {
        if let it = try? typeInfo(of: self.type) {
        return it.isOptional
            ? "\(it.elementType!)?"
            : "\(it.mangledName) \(kind)"
        } else {
            // likely an objCClassWrapper
            return "<\(type) \(kind)>"
        }
    }
}

public extension TypeInfo {
    
    func dump(indent: Int = 0) {
        var str: String = ""
        if indent == 0 {
            pr (indent: indent, to: &str)
        }
        dump(indent: indent, to: &str)
        Swift.print(str)
    }
    
    func pr(indent: Int = 0, to: inout String) {
        let tab = String(repeating: "\t", count: indent)
        if is_objCClassWrapper {
            Swift.print(tab, kind, mangledName, "(objc)")
        } else {
            Swift.print(tab, kind, mangledName)
        }
    }
    
    func dump(indent: Int = 0, to: inout String) {
        guard kind == .class || kind == .struct // || !isBuiltin
        else { return }
        
        for p in self.properties where p.kind != .opaque && p.kind != .objCClassWrapper {
            p.pr (indent: indent + 1, to: &to)
            if !p.sealed, let pinfo = try? typeInfo(of: p.type) {
                pinfo.dump(indent: indent + 1, to: &to)
            }
        }
    }
}

public extension PropertyInfo {
    
    func pr(indent: Int = 0, to: inout String) {
        let tab = String(repeating: "\t", count: indent)
        Swift.print(tab, name, self.description())
    }
}
