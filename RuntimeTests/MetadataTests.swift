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

    func testProtocolMetadata() {
        var md = ProtocolMetadata(type: MyProtocol.self)
        print(md.metadata.pointee)
        print(md.protocolDescriptor.pointee)
        print(md.mangledName())
    }
    
}


@objc fileprivate protocol MyProtocol {
    func doSomething(value: Int) -> Bool
}
