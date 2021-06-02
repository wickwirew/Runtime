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

class FactoryTests: XCTestCase {

    static var allTests: [(String, (FactoryTests) -> () throws -> Void)] {
        return [
            ("testStruct", testStruct),
            ("testStructUntyped", testStructUntyped),
            ("testClass", testClass),
            ("testGenericClass", testGenericClass)
        ]
    }
    
    func testStruct() throws {
        let person: PersonStruct = try createInstance()
        XCTAssert(person.firstname == "")
        XCTAssert(person.lastname == "")
        XCTAssert(person.age == 0)
        XCTAssert(person.pet.name == "")
        XCTAssert(person.pet.age == 0)
        XCTAssert(person.favoriteNumbers == [])
    }
    
    func testStructUntyped() throws {
        let result = try createInstance(of: PersonStruct.self)
        let person = result as! PersonStruct
        XCTAssert(person.firstname == "")
        XCTAssert(person.lastname == "")
        XCTAssert(person.age == 0)
        XCTAssert(person.pet.name == "")
        XCTAssert(person.pet.age == 0)
        XCTAssert(person.favoriteNumbers == [])
    }
    
    func testClass() throws {
        let person: PersonClass<Int> = try createInstance()
        XCTAssert(person.firstname == "")
        XCTAssert(person.lastname == "")
        XCTAssert(person.age == 0)
        XCTAssert(person.pet.name == "")
        XCTAssert(person.pet.age == 0)
        XCTAssert(person.favoriteNumbers == [])
    }
    
    func testGenericClass() throws {
        class B {}
        class A<T> { let a: Int = 0; let b = B() }
        let a: A<Int> = try createInstance()
        XCTAssert(a.a == 0)
    }
    
    func testEnumWithoutRawValue() throws {
        enum TestEnum {
            case one
            case two
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
    }
    
    func testEnumWithStringRawValue() throws {
        enum TestEnum: String {
            case one = "test"
            case two = "anOtherTest"
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
    }
    
    func testEnumWithIntRawValue() throws {
        enum TestEnum: Int {
            case one = 42
            case two = 0
            case three = 41
            case four = 100
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        XCTAssert(testEnum == .one)
    }
    
    func testEnumWithAssociatedValue() throws {
        enum TestEnum {
            case one(number: Int, text: String)
            case two(Int)
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        switch testEnum {
        case let .one(first, second):
            XCTAssertEqual(first, 0)
            XCTAssertEqual(second, "")
        default:
            XCTFail("Expected an `one` case.")
        }
    }
    
    func testEnumWithComplexAssociatedValue() throws {
        struct Person {
            let name: String
        }
        
        enum TestEnum {
            case one(person: Person)
            case two
        }
        
        let result = try createInstance(of: TestEnum.self)
        let testEnum = result as! TestEnum
        
        switch testEnum {
        case let .one(person):
            XCTAssertEqual(person.name, "")
        default:
            XCTFail("Expected an `one` case.")
        }
    }
}

fileprivate struct PersonStruct {
    var firstname = "Jobie"
    var lastname = "Gillis"
    var age = 40
    var pet = PetStruct()
    var favoriteNumbers = [1, 2, 3, 4, 5]
}

fileprivate struct PetStruct {
    var name = "Nacho"
    var age = 12
    init() {}
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

fileprivate class PersonClass<T> {
    var firstname = "Jobie"
    var lastname = "Gillis"
    var age = 40
    var pet = PetClass()
    var favoriteNumbers = [1, 2, 3, 4, 5]
}

fileprivate class PetClass {
    var name = "Nacho"
    var age = 12
    init() {}
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
