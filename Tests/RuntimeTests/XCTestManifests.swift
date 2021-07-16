import XCTest

extension FactoryTests {
    static let __allTests = [
        ("testStruct", testStruct),
        ("testStructUntyped", testStructUntyped),
        ("testClass", testClass),
        ("testGenericClass", testGenericClass)
    ]
}

extension GetSetClassTests {
    static let __allTests = [
        ("testGet", testGet),
        ("testGetArray", testGetArray),
        ("testGetArrayUntyped", testGetArrayUntyped),
        ("testGetArrayUntypedObject", testGetArrayUntypedObject),
        ("testGetArrayUntypedValue", testGetArrayUntypedValue),
        ("testGetClass", testGetClass),
        ("testGetClassUntyped", testGetClassUntyped),
        ("testGetClassUntypedObject", testGetClassUntypedObject),
        ("testGetClassUntypedValue", testGetClassUntypedValue),
        ("testGetUntyped", testGetUntyped),
        ("testGetUntypedObject", testGetUntypedObject),
        ("testGetUntypedValue", testGetUntypedValue),
        ("testNSObjectBaseClass", testNSObjectBaseClass),
        ("testSet", testSet),
        ("testSetArray", testSetArray),
        ("testSetArrayUntyped", testSetArrayUntyped),
        ("testSetArrayUntypedObject", testSetArrayUntypedObject),
        ("testSetArrayUntypedValue", testSetArrayUntypedValue),
        ("testSetClass", testSetClass),
        ("testSetClassUntyped", testSetClassUntyped),
        ("testSetClassUntypedObject", testSetClassUntypedObject),
        ("testSetClassUntypedValue", testSetClassUntypedValue),
        ("testSetUntyped", testSetUntyped),
        ("testSetUntypedObject", testSetUntypedObject),
        ("testSetUntypedValue", testSetUntypedValue)
    ]
}

extension GetSetStructTests {
    static let __allTests = [
        ("testGet", testGet),
        ("testGetSimple", testGetSimple),
        ("testGetArray", testGetArray),
        ("testGetArrayUntyped", testGetArrayUntyped),
        ("testGetArrayUntypedObject", testGetArrayUntypedObject),
        ("testGetArrayUntypedValue", testGetArrayUntypedValue),
        ("testGetStruct", testGetStruct),
        ("testGetStructUntyped", testGetStructUntyped),
        ("testGetStructUntypedObject", testGetStructUntypedObject),
        ("testGetStructUntypedValue", testGetStructUntypedValue),
        ("testGetUntyped", testGetUntyped),
        ("testGetUntypedObject", testGetUntypedObject),
        ("testGetUntypedValue", testGetUntypedValue),
        ("testSet", testSet),
        ("testSetArray", testSetArray),
        ("testSetArrayUntyped", testSetArrayUntyped),
        ("testSetArrayUntypedObject", testSetArrayUntypedObject),
        ("testSetArrayUntypedValue", testSetArrayUntypedValue),
        ("testSetCasting", testSetCasting),
        ("testSetCastingFailure", testSetCastingFailure),
        ("testSetStruct", testSetStruct),
        ("testSetStructUntyped", testSetStructUntyped),
        ("testSetStructUntypedObject", testSetStructUntypedObject),
        ("testSetStructUntypedValue", testSetStructUntypedValue),
        ("testSetUntyped", testSetUntyped),
        ("testSetUntypedObject", testSetUntypedObject),
        ("testSetUntypedValue", testSetUntypedValue)
    ]
}

extension MetadataTests {
    static let __allTests = [
        ("testClass", testClass),
        ("testResilientClass", testResilientClass),
        ("testStruct", testStruct),
        ("testGenericStruct", testGenericStruct),
        ("testNestedStruct", testNestedStruct),
        ("testProtocol", testProtocol),
        ("testTuple", testTuple),
        ("testTupleNoLabels", testTupleNoLabels),
        ("testFunction", testFunction),
        ("testFunctionThrows", testFunctionThrows),
        ("testVoidFunction", testVoidFunction),
        ("testEnum", testEnum),
        ("testEnumTestEnumWithPayload", testEnumTestEnumWithPayload),
        ("testObjcEnum", testObjcEnum),
        ("testOptional", testOptional)
    ]
}

extension ValuePointerTests {
    static let __allTests = [
        ("testAnyClassValuePointer", testAnyClassValuePointer),
        ("testAnyStructValuePointer", testAnyStructValuePointer),
        ("testClassValuePointer", testClassValuePointer),
        ("testProtocolClassValuePointer", testProtocolClassValuePointer),
        ("testProtocolStructValuePointer", testProtocolStructValuePointer),
        ("testStructValuePointer", testStructValuePointer)
    ]
}

extension ValueWitnessTableTests {
    static let __allTests = [
        ("testAlignment", testAlignment),
        ("testSize", testSize),
        ("testStride", testStride)
    ]
}

#if !os(macOS) && !os(iOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FactoryTests.__allTests),
        testCase(GetSetClassTests.__allTests),
        testCase(GetSetStructTests.__allTests),
        testCase(MetadataTests.__allTests),
        testCase(ValuePointerTests.__allTests),
        testCase(ValueWitnessTableTests.__allTests)
    ]
}
#endif
