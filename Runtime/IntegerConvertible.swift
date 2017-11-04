//
//  IntegerConvertible.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


protocol IntegerConvertible {
    func getInt() -> Int
}

extension Int: IntegerConvertible {
    func getInt() -> Int {
        return self
    }
}

extension Int32: IntegerConvertible {
    func getInt() -> Int {
        return Int(self)
    }
}
