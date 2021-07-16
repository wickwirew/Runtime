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

class EnumFactoryTests: XCTestCase {
    static var allTests: [(String, (EnumFactoryTests) -> () throws -> Void)] {
        return [
            ("testEmptyEnum", testEmptyEnum),
            ("testSingleCaseEnum", testSingleCaseEnum),
            ("testEnumWithoutRawValue", testCLikeEnumWithoutRawValue),
            ("testEnumWithStringRawValue", testCLikeEnumWithStringRawValue),
            ("testEnumWithIntRawValue", testCLikeEnumWithIntRawValue),
            ("testSinglePlayloadEnum", testSinglePlayloadEnum),
            ("testSinglePlayloadEnumExtended", testSinglePlayloadEnumExtended),
            ("testMultiPlayloadEnumWithUnallignedType", testMultiPlayloadEnumWithUnallignedType),
            ("testMultiPlayloadEnumCommonTag", testMultiPlayloadEnumCommonTag),
            ("testMultiPlayloadEnumWithNestedType", testMultiPlayloadEnumWithNestedType),
        ]
    }
    
    func testEmptyEnum() throws {
        let expectation = XCTestExpectation(description: "Function is called")
        
        enum TestEnum {
            func testFunction(_ expectation: XCTestExpectation) {
                expectation.fulfill()
            }
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum: TestEnum = result as! TestEnum
        testEnum.testFunction(expectation)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSingleCaseEnum() throws {
        enum TestEnum {
            case test
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .test)
        
        XCTAssert(try allCases(of: TestEnum.self) == [.test])
    }
    
    func testSingleCaseEnumWithAssociatedValue() throws {
        enum TestEnum: Equatable {
            case test(Int, Double)
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .test(0, 0.0))
        
        XCTAssert(try allCases(of: TestEnum.self) == [.test(0, 0.0)])
    }
    
    func testCLikeEnumWithoutRawValue() throws {
        enum TestEnum {
            case one
            case two
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
        
        XCTAssert(try allCases(of: TestEnum.self) == [.one, .two])
    }
    
    func testCLikeEnumWithStringRawValue() throws {
        enum TestEnum: String {
            case one = "test"
            case two = "anOtherTest"
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
        XCTAssert(testEnum.rawValue == "test")
        
        XCTAssert(try allCases(of: TestEnum.self) == [.one, .two])
    }
    
    func testCLikeEnumWithIntRawValue() throws {
        enum TestEnum: Int {
            case one = 42
            case two = 0
            case three = 41
            case four = 100
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
        XCTAssert(testEnum.rawValue == 42)
        
        XCTAssert(try allCases(of: TestEnum.self) == [.one, .two, .three, .four])
    }
    
    func testSinglePlayloadEnum() throws {
        enum TestEnum: Equatable {
            case one
            case two(UnicodeScalar)
            case three
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        XCTAssertEqual(testEnum, .one)
        
        XCTAssert(try allCases(of: TestEnum.self) == [
            TestEnum.one,
            TestEnum.two(UnicodeScalar()),
            TestEnum.three
        ])
    }
    
    func testSinglePlayloadEnumExtended() throws {
        enum TestEnum: Equatable {
            case one
            case two(UnicodeScalar)
            case three
        }
        
        enum TestEnumExtended: Equatable {
            case oneToThree(TestEnum)
            case four
            case five
            case six
        }
        
        let result = try createInstance(of: TestEnumExtended.self)
        let testEnumExtended = result as! TestEnumExtended
        
        XCTAssertEqual(testEnumExtended, .oneToThree(.one))
        
        XCTAssert(try allCases(of: TestEnumExtended.self) == [
            TestEnumExtended.oneToThree(.one),
            TestEnumExtended.four,
            TestEnumExtended.five,
            TestEnumExtended.six
        ])
    }
    
    func testMultiPlayloadEnumWithUnallignedType() throws {
        enum TestEnum: Equatable {
            case one(UnicodeScalar)
            case two(UnicodeScalar)
            case three(UnicodeScalar)
            case four(UnicodeScalar)
            case five
            case six
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        switch testEnum {
        case let .one(scalar):
            XCTAssertEqual(scalar, UnicodeScalar())
        default:
            XCTFail("Expected an `one` case.")
        }
        
        XCTAssert(try allCases(of: TestEnum.self) == [
            TestEnum.one(UnicodeScalar()),
            TestEnum.two(UnicodeScalar()),
            TestEnum.three(UnicodeScalar()),
            TestEnum.four(UnicodeScalar()),
            TestEnum.five,
            TestEnum.six
        ])
    }
    
    func testMultiPlayloadEnumCommonTag() throws {
        enum TestEnum: Equatable {
            case one(Int)
            case two(Double)
            case three(UInt64)
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        switch testEnum {
        case let .one(number):
            XCTAssertEqual(number, 0)
        default:
            XCTFail("Expected an `one` case.")
        }
        
        XCTAssert(try allCases(of: TestEnum.self) == [.one(0), .two(0.0), .three(0)])
    }
    
    func testMultiPlayloadEnumWithNestedType() throws {
        struct Person: Equatable {
            let name: String
            let age: UInt64
        }
        
        enum TestEnum: Equatable {
            case one(person: Person, array: Array<Person>, dictionary: Dictionary<Int, Person>)
            case two
            case three(Int)
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        switch testEnum {
        case let .one(person, array, dictionary):
            XCTAssertEqual(person, Person(name: "", age: 0))
            XCTAssertEqual(array, [])
            XCTAssertEqual(dictionary, [:])
        default:
            XCTFail("Expected an `one` case.")
        }
        
        XCTAssert(try allCases(of: TestEnum.self) == [
            TestEnum.one(person: Person(name: "", age: 0), array: [], dictionary: [:]),
            TestEnum.two,
            TestEnum.three(0)
        ])
    }
}
