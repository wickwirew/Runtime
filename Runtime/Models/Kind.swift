//
//  Kind.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


public enum Kind: Int {
    
    case unknown = 0
    case `struct` = 1
    case `enum` = 2
    case opaque = 8
    case tuple = 9
    case function = 10
    case `protocol` = 12
    case metatype = 13
    case `class` = 4096
    
    init(int: Int) {
        if let value = Kind(rawValue: int) {
            self = value
        } else if int >= 4096 {
            self = .class
        } else {
            self = .unknown
        }
    }
    
    init(type: Any.Type) {
        let pointer = metadataPointer(type: type)
        self.init(int: pointer.pointee)
    }
}
