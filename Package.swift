// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Runtime",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13), .tvOS(.v13),
    ],
    products: [
        .library(name: "Runtime", targets: ["Runtime"]),
        .library(name: "CRuntime", targets: ["CRuntime"])
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
            dependencies: ["Runtime"])
    ],
    swiftLanguageVersions: [.v5]
)
