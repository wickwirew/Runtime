//
//  MetadataRelativePointer.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct MetadataRelativePointer<Offset: IntegerConvertible, Pointee> {
    
    var offset: Offset
    
    mutating func pointee(metadata: UnsafePointer<Int>) -> Pointee {
        return advanced(metadata: metadata).pointee
    }
    
    mutating func advanced(metadata: UnsafePointer<Int>) -> UnsafeMutablePointer<Pointee> {
        return metadata.raw.advanced(by: offset.getInt()).assumingMemoryBound(to: Pointee.self).mutable
    }
}
