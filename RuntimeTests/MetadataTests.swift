//
//  MetadataTests.swift
//  RuntimeTests
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

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
