//
//  ValuePointerTests.swift
//  RuntimeTests
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import XCTest
@testable import Runtime


class ValuePointerTests: XCTestCase {
    
    func testStructValuePointer() throws {
        var person = PersonStruct()
        try withValuePointer(of: &person) { p in
            XCTAssert(p.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testProtocolStructValuePointer() throws {
        var person: PersonProtocol = PersonStruct()
        try withValuePointer(of: &person) { p in
            XCTAssert(p.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testClassValuePointer() throws {
        var person = PersonClass()
        try withValuePointer(of: &person) { p in
            let base = p.advanced(by: ClassHeader.size())
            XCTAssert(base.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testProtocolClassValuePointer() throws {
        var person: PersonProtocol = PersonClass()
        try withValuePointer(of: &person) { p in
            let base = p.advanced(by: ClassHeader.size())
            XCTAssert(base.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testAnyClassValuePointer() throws {
        var person: Any = PersonClass()
        try withValuePointer(of: &person) { p in
            let base = p.advanced(by: ClassHeader.size())
            XCTAssert(base.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testAnyStructValuePointer() throws {
        var person: Any = PersonStruct()
        try withValuePointer(of: &person) { p in
            XCTAssert(p.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
}


fileprivate protocol PersonProtocol {
    var fistname: String { get set }
    var lastname: String { get set }
    var age: Int { get set }
}

fileprivate struct PersonStruct: PersonProtocol {
    var fistname = "Wes"
    var lastname = "Wickwire"
    var age = 25
}

fileprivate class PersonClass: PersonProtocol {
    var fistname = "Wes"
    var lastname = "Wickwire"
    var age = 25
}
