//
//  Metadata.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


func metadataPointer(type: Any.Type) -> UnsafeMutablePointer<Int> {
    return unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
}


func strings(from pointer: UnsafePointer<CChar>, n: Int) -> [String] {
    var pointer = pointer
    var result = [String]()
    
    for _ in 0..<n {
        result.append(String(cString: pointer))
        pointer = pointer.advance(to: 0).advanced(by: 1)
    }
    
    return result
}
