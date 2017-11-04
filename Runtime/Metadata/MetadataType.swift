//
//  MetadataType.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



protocol MetadataType {
    associatedtype Layout: MetadataLayoutType
    var type: Any.Type { get set }
    var metadata: UnsafeMutablePointer<Layout> { get set }
    var base: UnsafeMutablePointer<Int> { get set }
}

extension MetadataType {
    
    var kind: Kind {
        return Kind(int: base.pointee)
    }
    
    var size: Int {
        return metadata.pointee.valueWitnessTable.pointee.size
    }
    
    var alignment: Int {
        return (metadata.pointee.valueWitnessTable.pointee.flags & ValueWitnessFlags.alignmentMask) + 1
    }
    
    var stride: Int {
        return metadata.pointee.valueWitnessTable.pointee.stride
    }
}
