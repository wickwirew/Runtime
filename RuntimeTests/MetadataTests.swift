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


class MetadataTests: XCTestCase {

    func testTuple() {
        let type = (a: Int, b: Bool, c: String).self
        let md = TupleMetadata(type: type)
        XCTAssert(md.labels() == ["a", "b", "c"])
        XCTAssert(md.numberOfElements() == 3)
    }
    
    func testTupleNoLabels() {
        let type = (Int, Bool, String).self
        let md = TupleMetadata(type: type)
        XCTAssert(md.labels() == [])
        XCTAssert(md.numberOfElements() == 3)
    }
    
    func testFunction() {
        let t = ((a: Int, b: Bool, c: String) -> String).self
        let md = FunctionMetadata(type: t)
        let info = md.info()
        XCTAssert(info.numberOfArguments == 3)
        XCTAssert(info.argumentTypes[0] == Int.self)
        XCTAssert(info.argumentTypes[1] == Bool.self)
        XCTAssert(info.argumentTypes[2] == String.self)
        XCTAssert(info.returnType == String.self)
        XCTAssert(!info.throws)
    }
    
    func testFunctionThrows() {
        let t = ((Int) throws -> String).self
        let md = FunctionMetadata(type: t)
        let info = md.info()
        XCTAssert(info.numberOfArguments == 1)
        XCTAssert(info.argumentTypes[0] == Int.self)
        XCTAssert(info.returnType == String.self)
        XCTAssert(info.throws)
    }
    
    func testVoidFunction() {
        let t = type(of: voidFunction)
        let md = FunctionMetadata(type: t)
        let info = md.info()
        XCTAssert(info.numberOfArguments == 0)
    }
    
}

func voidFunction() {
    
}

@objc fileprivate protocol MyProtocol {
    func doSomething(value: Int) -> Bool
}
