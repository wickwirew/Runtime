// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "cruntime",
    pkgConfig: "cruntime",
    products: [
        .library(name: "cruntime", targets: ["cruntime"])
    ]
)
