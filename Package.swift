// swift-tools-version:4.2
import PackageDescription
let package = Package(
    name: "Runtime",
    products: [
        .library(
            name: "Runtime",
            targets: ["Runtime"]),
        ],
        dependencies: [
            .package(url: "https://github.com/wickwirew/CRuntime.git", from: "1.0.0")
        ],
    targets: [
        .target(
            name: "Runtime",
            dependencies: ["CRuntime"]),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"])
    ],
    swiftLanguageVersions: [.v4_2]
)
