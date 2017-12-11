// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Runtime",
    products: [
        .library(
            name: "Runtime",
            targets: ["Runtime"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Runtime",
            dependencies: []),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"]),
    ],
    swiftLanguageVersions: [4]
)
