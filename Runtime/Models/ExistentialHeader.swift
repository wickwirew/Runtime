//
//  ExistentialHeader.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


struct ExistentialHeader {
    let witnessTable: Int
    let strongRetainCounts: Int32
    let weakRetainCounts: Int32
}


extension ExistentialHeader {
    
    static func size() -> Int {
        return MemoryLayout<ExistentialHeader>.size
    }
}
