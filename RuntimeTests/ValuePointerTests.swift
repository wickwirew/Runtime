// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
            let base = p.advanced(by: existentialHeaderSize)
            XCTAssert(base.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testProtocolClassValuePointer() throws {
        var person: PersonProtocol = PersonClass()
        try withValuePointer(of: &person) { p in
            let base = p.advanced(by: existentialHeaderSize)
            XCTAssert(base.assumingMemoryBound(to: String.self).pointee == "Wes")
        }
    }
    
    func testAnyClassValuePointer() throws {
        var person: Any = PersonClass()
        try withValuePointer(of: &person) { p in
            let base = p.advanced(by: existentialHeaderSize)
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
