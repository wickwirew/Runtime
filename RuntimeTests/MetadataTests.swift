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
    
}

@objc fileprivate protocol MyProtocol {
    func doSomething(value: Int) -> Bool
}
