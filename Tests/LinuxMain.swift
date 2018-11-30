import XCTest

import RuntimeTests

var tests = [XCTestCaseEntry]()
tests += RuntimeTests.__allTests()

XCTMain(tests)
