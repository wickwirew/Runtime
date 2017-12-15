import PackageDescription

let package = Package(
    name: "Runtime",
    targets: [
        .target(
            name: "Runtime",
            dependencies: []),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"]),
        ],
    exclude: [
        "RuntimeTests",
        "Resources"
    ],
)
