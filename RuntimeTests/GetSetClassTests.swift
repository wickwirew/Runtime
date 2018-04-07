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


class GetSetClassTests: XCTestCase {
    
    static var allTests: [(String, (GetSetClassTests) -> () throws -> Void)] {
        return [
            ("testGet", testGet),
            ("testGetUntypedValue", testGetUntypedValue),
            ("testGetUntypedObject", testGetUntypedObject),
            ("testGetUntyped", testGetUntyped),
            ("testGetClass", testGetClass),
            ("testGetClassUntypedValue", testGetClassUntypedValue),
            ("testGetClassUntypedObject", testGetClassUntypedObject),
            ("testGetClassUntyped", testGetClassUntyped),
            ("testGetArray", testGetArray),
            ("testGetArrayUntypedValue", testGetArrayUntypedValue),
            ("testGetArrayUntypedObject", testGetArrayUntypedObject),
            ("testGetArrayUntyped", testGetArrayUntyped),
            
            ("testSet", testSet),
            ("testSetUntypedValue", testSetUntypedValue),
            ("testSetUntypedObject", testSetUntypedObject),
            ("testSetUntyped", testSetUntyped),
            ("testSetClass", testSetClass),
            ("testSetClassUntypedValue", testSetClassUntypedValue),
            ("testSetClassUntypedObject", testSetClassUntypedObject),
            ("testSetClassUntyped", testSetClassUntyped),
            ("testSetArray", testSetArray),
            ("testSetArrayUntypedValue", testSetArrayUntypedValue),
            ("testSetArrayUntypedObject", testSetArrayUntypedObject),
            ("testSetArrayUntyped", testSetArrayUntyped)
        ]
    }
    
    func testGet() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        let person = Person()
        let name: String = try firstname.get(from: person)
        XCTAssert(name == "Wes")
    }
    
    func testGetUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        let person = Person()
        let name: Any = try firstname.get(from: person)
        XCTAssert((name as! String) == "Wes")
    }
    
    func testGetUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        let person: Any = Person()
        let name: String = try firstname.get(from: person)
        XCTAssert(name == "Wes")
    }
    
    func testGetUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        let person: Any = Person()
        let name: Any = try firstname.get(from: person)
        XCTAssert((name as! String) == "Wes")
    }
    
    func testGetClass() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        let person = Person()
        let value: Pet = try pet.get(from: person)
        XCTAssert(value.name == "Marley")
    }
    
    func testGetClassUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        let person = Person()
        let value: Any = try pet.get(from: person)
        XCTAssert((value as! Pet).name == "Marley")
    }
    
    func testGetClassUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        let person: Any = Person()
        let value: Pet = try pet.get(from: person)
        XCTAssert(value.name == "Marley")
    }
    
    func testGetClassUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        let person: Any = Person()
        let value: Any = try pet.get(from: person)
        XCTAssert((value as! Pet).name == "Marley")
    }
    
    func testGetArray() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        let person = Person()
        let value: [Int] = try favoriteNumbers.get(from: person)
        XCTAssert(value == [1,2,3,4,5])
    }
    
    func testGetArrayUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        let person = Person()
        let value: Any = try favoriteNumbers.get(from: person)
        XCTAssert(value as! [Int] == [1,2,3,4,5])
    }
    
    func testGetArrayUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        let person: Any = Person()
        let value: [Int] = try favoriteNumbers.get(from: person)
        XCTAssert(value == [1,2,3,4,5])
    }
    
    func testGetArrayUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        let person: Any = Person()
        let value: Any = try favoriteNumbers.get(from: person)
        XCTAssert(value as! [Int] == [1,2,3,4,5])
    }
    
    
    func testSet() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        var person = Person()
        try firstname.set(value: "John", on: &person)
        XCTAssert(person.firstname == "John")
    }
    
    func testSetUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        var person = Person()
        let new: Any = "John"
        try firstname.set(value: new, on: &person)
        XCTAssert(person.firstname == "John")
    }
    
    func testSetUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        var person: Any = Person()
        try firstname.set(value: "John", on: &person)
        XCTAssert((person as! Person).firstname == "John")
    }
    
    func testSetUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let firstname = try info.property(named: "firstname")
        var person: Any = Person()
        let new: Any = "John"
        try firstname.set(value: new, on: &person)
        XCTAssert((person as! Person).firstname == "John")
    }
    
    func testSetArray() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        var person = Person()
        let new = [5,4,3,2,1]
        try favoriteNumbers.set(value: new, on: &person)
        XCTAssert(person.favoriteNumbers == [5,4,3,2,1])
    }
    
    func testSetArrayUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        var person = Person()
        let new = [5,4,3,2,1]
        try favoriteNumbers.set(value: new, on: &person)
        XCTAssert(person.favoriteNumbers == [5,4,3,2,1])
    }
    
    func testSetArrayUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        var person: Any = Person()
        let new = [5,4,3,2,1]
        try favoriteNumbers.set(value: new, on: &person)
        XCTAssert((person as! Person).favoriteNumbers == [5,4,3,2,1])
    }
    
    func testSetArrayUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let favoriteNumbers = try info.property(named: "favoriteNumbers")
        var person: Any = Person()
        let new = [5,4,3,2,1]
        try favoriteNumbers.set(value: new, on: &person)
        XCTAssert((person as! Person).favoriteNumbers == [5,4,3,2,1])
    }
    
    func testSetClass() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        var person = Person()
        let new = Pet(name: "Rex", age: 9)
        try pet.set(value: new, on: &person)
        XCTAssert(person.pet.name == "Rex")
    }
    
    func testSetClassUntypedValue() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        var person = Person()
        let new = Pet(name: "Rex", age: 9)
        try pet.set(value: new, on: &person)
        XCTAssert(person.pet.name == "Rex")
    }
    
    func testSetClassUntypedObject() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        var person: Any = Person()
        let new = Pet(name: "Rex", age: 9)
        try pet.set(value: new, on: &person)
        XCTAssert((person as! Person).pet.name == "Rex")
    }
    
    func testSetClassUntyped() throws {
        let info = try typeInfo(of: Person.self)
        let pet = try info.property(named: "pet")
        var person: Any = Person()
        let new = Pet(name: "Rex", age: 9)
        try pet.set(value: new, on: &person)
        XCTAssert((person as! Person).pet.name == "Rex")
    }
}


fileprivate class Person {
    var firstname = "Wes"
    var lastname = "Wickwire"
    var age = 25
    var pet = Pet()
    var favoriteNumbers = [1,2,3,4,5]
}

fileprivate class Pet {
    var name = "Marley"
    var age = 12
    init() {}
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}


