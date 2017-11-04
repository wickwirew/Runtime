//
//  RelativeVectorPointer.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


struct RelativeVectorPointer<Offset: IntegerConvertible, Pointee>: RelativePointerType {
    var offset: OffsetType
    typealias PointeeType = Pointee
    typealias OffsetType = Offset
    
    mutating func vector(n: IntegerConvertible) -> [PointeeType] {
        return advanced().vector(n: n)
    }
}

extension RelativeVectorPointer: CustomStringConvertible {
    var description: String {
        return "\(offset)"
    }
}
