// MIT License
//
// Copyright (c) 2021 Paul Schmiedmayer
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

class TupleFactoryTests: XCTestCase {
    static var allTests: [(String, (TupleFactoryTests) -> () throws -> Void)] {
        return [
            ("testEmptyTuple", testEmptyTuple),
            ("testPrimitiveValueTuple", testPrimitiveValueTuple),
            ("testPrimitiveTupleWithTwoElements", testPrimitiveTupleWithTwoElements),
            ("testPrimitiveTupleWithTenElements", testPrimitiveTupleWithTenElements),
            ("testComplexTuple", testComplexTuple)
        ]
    }
    
    func testEmptyTuple() throws {
        typealias TestTuple = ()
        
        let result = try createInstance(of: TestTuple.self)
        let testTuple: () = result as! TestTuple
        
        XCTAssert(testTuple == ())
    }
    
    func testPrimitiveValueTuple() throws {
        typealias TestTuple = (String)
        
        let result = try createInstance(of: TestTuple.self)
        let testTuple = result as! TestTuple
        
        XCTAssert(testTuple == "")
    }
    
    func testPrimitiveTupleWithTwoElements() throws {
        typealias TestTuple = (name: String, age: Int)
        
        let result = try createInstance(of: TestTuple.self)
        let testTuple = result as! TestTuple
        
        XCTAssert(testTuple.name == "")
        XCTAssert(testTuple.age == 0)
    }
    
    func testPrimitiveTupleWithTenElements() throws {
        typealias TestTuple = (String, Int, Bool, Double, Float, Array<UInt8>, Dictionary<UInt16, UInt32>, Set<UInt64>, Character, Int32)
        
        let result = try createInstance(of: TestTuple.self)
        let testTuple = result as! TestTuple
        
        XCTAssert(testTuple.0 == "")
        XCTAssert(testTuple.1 == 0)
        XCTAssert(testTuple.2 == false)
        XCTAssert(testTuple.3 == 0.0)
        XCTAssert(testTuple.4 == 0.0)
        XCTAssert(testTuple.5 == [])
        XCTAssert(testTuple.6 == [:])
        XCTAssert(testTuple.7 == [])
        XCTAssert(testTuple.8 == Character())
        XCTAssert(testTuple.9 == 0)
    }
    
    func testComplexTuple() throws {
        struct Person: Equatable {
            let name: String
            let age: UInt16
        }
        
        typealias TestTuple = (Person, Person)
        
        let result = try createInstance(of: TestTuple.self)
        let testTuple = result as! TestTuple
        
        XCTAssert(testTuple.0 == Person(name: "", age: 0))
        XCTAssert(testTuple.1 == Person(name: "", age: 0))
    }
}
