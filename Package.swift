// swift-tools-version:5.0
import PackageDescription
let package = Package(
    name: "Runtime",
    products: [
        .library(
            name: "Runtime",
            targets: ["Runtime"])
        ],
        dependencies: [
            .package(url: "https://github.com/swiftwasm/swift-corelibs-xctest.git", .branch("swiftwasm")),
        ],
    targets: [
        .target(
            name: "Runtime",
            dependencies: ["CRuntime"]),
        .target(
            name: "CRuntime",
            dependencies: []),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime", "XCTest"])
    ],
    swiftLanguageVersions: [.v5]
)
