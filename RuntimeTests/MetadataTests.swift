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
        print(md.labels())
        print(md.elements())
    }
    
}


@objc fileprivate protocol MyProtocol {
    func doSomething(value: Int) -> Bool
}
