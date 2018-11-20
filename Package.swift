// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Runtime",
    products: [
        .library(
            name: "Runtime",
            targets: ["Runtime"]),
        ],
    dependencies: [.package(path: "./cruntime")],
    targets: [
        .target(
            name: "Runtime",
            dependencies: ["cruntime"],
            path: "Runtime"),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"],
            path: "RuntimeTests"),
        ],
    swiftLanguageVersions: [.v4_2]
)
