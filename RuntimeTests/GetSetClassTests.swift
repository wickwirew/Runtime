//
//  GetSetClassTests.swift
//  RuntimeTests
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import XCTest
@testable import Runtime


class GetSetClassTests: XCTestCase {
    
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


