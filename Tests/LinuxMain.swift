import XCTest
@testable import RuntimeTests

XCTMain([
    testCase(ValuePointerTests.allTests),
    testCase(GetSetStructTests.allTests),
    testCase(GetSetClassTests.allTests),
    testCase(ValueWitnessTableTests.allTests),
    testCase(MetadataTests.allTests),
    testCase(FactoryTests.allTests),
])
