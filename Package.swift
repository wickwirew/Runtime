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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Runtime",
            dependencies: []),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"]),
    ]
)
