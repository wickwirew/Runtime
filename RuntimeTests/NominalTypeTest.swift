//
//  NominalTypeTest.swift
//  Runtime
//
//  Created by Wes Wickwire on 6/9/18.
//  Copyright © 2018 Wes Wickwire. All rights reserved.
//

import XCTest
@testable import Runtime

class NominalTypeTest: XCTestCase {

    func testName() {
        var md = StructMetadata(type: MyStruct.self)
        XCTAssert(md.mangledName() == "MyStruct")
        XCTAssert(md.numberOfFields() == 3)
        XCTAssert(md.fieldOffsets() == [0,8,16])
        md.getFields()
    }
}

fileprivate struct MyStruct {
    let a,b,c: Int
}
