//
//  RelativePointer.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation




protocol RelativePointerType {
    associatedtype OffsetType: IntegerConvertible
    associatedtype PointeeType
    var offset: OffsetType { get set }
}


struct RelativePointer<Offset: IntegerConvertible, Pointee>: RelativePointerType {
    var offset: OffsetType
    typealias PointeeType = Pointee
    typealias OffsetType = Offset
}

extension RelativePointerType {
    mutating func pointee() -> PointeeType {
        return advanced().pointee
    }
    
    mutating func advanced() -> UnsafeMutablePointer<PointeeType> {
        let offsetCopy = self.offset
        return withUnsafePointer(to: &self) { p in
            return p.raw.advanced(by: offsetCopy.getInt()).assumingMemoryBound(to: PointeeType.self).mutable
        }
    }
}

extension RelativePointer: CustomStringConvertible {
    var description: String {
        return "\(offset)"
    }
}
