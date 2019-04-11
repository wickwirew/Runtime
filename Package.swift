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
             .package(url: "https://github.com/wickwirew/CRuntime.git", from: "2.1.1")
        ],
    targets: [
        .target(
            name: "Runtime",
            dependencies: ["CRuntime"]),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"])
    ],
    swiftLanguageVersions: [.v5]
)
