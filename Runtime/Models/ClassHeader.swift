//
//  ClassHeader.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct ClassHeader {
    var isaPointer: Int
    var strongRetainCounts: Int32
    var weakRetainCounts: Int32
}


extension ClassHeader {
    
    static func size() -> Int {
        return MemoryLayout<ClassHeader>.size
    }
}
