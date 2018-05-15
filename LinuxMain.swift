import XCTest
@testable import RuntimeTests

XCTMain([
     testCase(GetSetClassTests.allTests),
     testCase(GetSetStructTests.allTests),
     testCase(FactoryTests.allTests),
     testCase(MetadataTests.allTests),
     testCase(ValuePointerTests.allTests),
     testCase(ValueWitnessTableTests.allTests),
])
