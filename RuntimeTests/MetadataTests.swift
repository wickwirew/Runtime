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


class MetadataTests: XCTestCase {
    
    static var allTests: [(String, (MetadataTests) -> () throws -> Void)] {
        return [
            ("testClass", testClass),
            ("testStruct", testStruct),
            ("testProtocol", testProtocol),
            ("testTuple", testTuple),
            ("testTupleNoLabels", testTupleNoLabels),
            ("testFunction", testFunction),
            ("testFunctionThrows", testFunctionThrows),
            ("testVoidFunction", testVoidFunction),
            ("testEnum", testEnum),
        ]
    }
    
    func testClass() {
        var md = ClassMetadata(type: MyClass<Int>.self)
        let info = md.toTypeInfo()
        XCTAssert(info.properties.first{$0.name == "baseProperty"} != nil)
        XCTAssert(info.inheritance[0] == BaseClass.self)
        XCTAssert(info.superClass == BaseClass.self)
        XCTAssert(info.mangledName != "")
        XCTAssert(info.kind == .class)
        XCTAssert(info.type == MyClass<Int>.self)
        XCTAssert(info.properties.count == 3)
        XCTAssert(info.size == MemoryLayout<MyClass<Int>>.size)
        XCTAssert(info.alignment == MemoryLayout<MyClass<Int>>.alignment)
        XCTAssert(info.stride == MemoryLayout<MyClass<Int>>.stride)
    }
    
    func testStruct() {
        var md = StructMetadata(type: MyStruct<Int>.self)
        let info = md.toTypeInfo()
        XCTAssert(info.kind == .struct)
        XCTAssert(info.type == MyStruct<Int>.self)
        XCTAssert(info.properties.count == 4)
        XCTAssert(info.size == MemoryLayout<MyStruct<Int>>.size)
        XCTAssert(info.alignment == MemoryLayout<MyStruct<Int>>.alignment)
        XCTAssert(info.stride == MemoryLayout<MyStruct<Int>>.stride)
    }
    
    func testProtocol() {
        var md = ProtocolMetadata(type: MyProtocol.self)
        let info = md.toTypeInfo()
        XCTAssert(info.kind == .existential)
        XCTAssert(info.type == MyProtocol.self)
        XCTAssert(info.size == MemoryLayout<MyProtocol>.size)
        XCTAssert(info.alignment == MemoryLayout<MyProtocol>.alignment)
        XCTAssert(info.stride == MemoryLayout<MyProtocol>.stride)
    }
    
    func testTuple() {
        let type = (a: Int, b: Bool, c: String).self
        var md = TupleMetadata(type: type)
        let info = md.toTypeInfo()
        XCTAssert(info.kind == .tuple)
        XCTAssert(info.type == (a: Int, b: Bool, c: String).self)
        XCTAssert(info.properties.count == 3)
        XCTAssert(info.size == MemoryLayout<(a: Int, b: Bool, c: String)>.size)
        XCTAssert(info.alignment == MemoryLayout<(a: Int, b: Bool, c: String)>.alignment)
        XCTAssert(info.stride == MemoryLayout<(a: Int, b: Bool, c: String)>.stride)
    }
    
    func testTupleNoLabels() {
        let type = (Int, Bool, String).self
        let md = TupleMetadata(type: type)
        XCTAssert(md.labels() == ["", "", ""])
        XCTAssert(md.numberOfElements() == 3)
    }
    
    func testFunction() throws {
        let info = try functionInfo(of: myFunc)
        XCTAssert(info.numberOfArguments == 3)
        XCTAssert(info.argumentTypes[0] == Int.self)
        XCTAssert(info.argumentTypes[1] == Bool.self)
        XCTAssert(info.argumentTypes[2] == String.self)
        XCTAssert(info.returnType == String.self)
        XCTAssert(!info.throws)
    }
    
    func testFunctionThrows() {
        let t = ((Int) throws -> String).self
        let md = FunctionMetadata(type: t)
        let info = md.info()
        XCTAssert(info.numberOfArguments == 1)
        XCTAssert(info.argumentTypes[0] == Int.self)
        XCTAssert(info.returnType == String.self)
        XCTAssert(info.throws)
    }
    
    func testVoidFunction() {
        let t = type(of: voidFunction)
        let md = FunctionMetadata(type: t)
        let info = md.info()
        XCTAssert(info.numberOfArguments == 0)
    }
    
    func testEnum() {
        var md = EnumMetadata(type: MyEnum<Int>.self)
        let info = md.toTypeInfo()
    }
    
}

fileprivate enum MyEnum<T>: Int {
    case a,b,c
}

func voidFunction() {
    
}

func myFunc(a: Int, b: Bool, c: String) -> String {
    return ""
}

fileprivate protocol MyProtocol {
    var a: Int { get set }
    func doSomething(value: Int) -> Bool
}

fileprivate class BaseClass {
    var baseProperty: Int = 0
}

fileprivate class MyClass<T>: BaseClass {
    var property: String = ""
    var gen: T
    init(g: T) {
        gen = g
    }
}

fileprivate struct MyStruct<T> {
    var a,b: Int
    var c: String
    var d: T
}
