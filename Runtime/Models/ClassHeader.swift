//
//  ClassHeader.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct ClassHeader {
    let isaPointer: Int
    let strongRetainCounts: Int32
    let weakRetainCounts: Int32
}


extension ClassHeader {
    
    static func size() -> Int {
        return MemoryLayout<ClassHeader>.size
    }
}
