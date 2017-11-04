//
//  FactoryTests.swift
//  RuntimeTests
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import XCTest
@testable import Runtime


class FactoryTests: XCTestCase {

    func testStruct() throws {
        let person: PersonStruct = try build()
        XCTAssert(person.firstname == "")
        XCTAssert(person.lastname == "")
        XCTAssert(person.age == 0)
        XCTAssert(person.pet.name == "")
        XCTAssert(person.pet.age == 0)
        XCTAssert(person.favoriteNumbers == [])
    }
    
    func testClass() throws {
        let person: PersonClass = try build()
        XCTAssert(person.firstname == "")
        XCTAssert(person.lastname == "")
        XCTAssert(person.age == 0)
        XCTAssert(person.pet.name == "")
        XCTAssert(person.pet.age == 0)
        XCTAssert(person.favoriteNumbers == [])
    }
    
}



fileprivate struct PersonStruct {
    var firstname = "Jobie"
    var lastname = "Gillis"
    var age = 40
    var pet = PetStruct()
    var favoriteNumbers = [1,2,3,4,5]
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

fileprivate class PersonClass {
    var firstname = "Jobie"
    var lastname = "Gillis"
    var age = 40
    var pet = PetClass()
    var favoriteNumbers = [1,2,3,4,5]
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
