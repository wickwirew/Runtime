import XCTest
@testable import ValuePointerTests
@testable import GetSetStructTests
@testable import GetSetClassTests
@testable import ValueWitnessTableTests
@testable import MetadataTests
@testable import FactoryTests

XCTMain([
    testCase(ValuePointerTests.allTests),
    testCase(GetSetStructTests.allTests),
    testCase(GetSetClassTests.allTests),
    testCase(ValueWitnessTableTests.allTests),
    testCase(MetadataTests.allTests),
    testCase(FactoryTests.allTests),
])
