//
//  MetadataRelativeVectorPointer.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct MetadataRelativeVectorPointer<Offset: IntegerConvertible, Pointee>: RelativePointerType {
    var offset: OffsetType
    typealias PointeeType = Pointee
    typealias OffsetType = Offset
    
    mutating func vector(metadata: UnsafePointer<Int>, n: IntegerConvertible) -> [PointeeType] {
        return metadata.advanced(by: offset.getInt()).vector(n: n.getInt()).map{ unsafeBitCast($0, to: PointeeType.self) }
    }
}

extension MetadataRelativeVectorPointer: CustomStringConvertible {
    var description: String {
        return "\(offset)"
    }
}
