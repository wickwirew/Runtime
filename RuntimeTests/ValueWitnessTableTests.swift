//
//  ValueWitnessTableTests.swift
//  RuntimeTests
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation
import XCTest
@testable import Runtime


class ValueWitnessTableTests: XCTestCase {

    func testSize() throws {
        let info = try typeInfo(of: Person.self)
        XCTAssert(info.size == MemoryLayout<Person>.size)
    }
    
    func testAlignment() throws {
        let info = try typeInfo(of: Person.self)
        XCTAssert(info.alignment == MemoryLayout<Person>.alignment)
    }
    
    func testStride() throws {
        let info = try typeInfo(of: Person.self)
        XCTAssert(info.stride == MemoryLayout<Person>.stride)
    }
    
}


fileprivate struct Person {
    let firstname: String
    let lastname: String
    let age: Int
}
