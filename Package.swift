// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BiasedDie",
    products: [
        .library(
            name: "BiasedDie",
            targets: ["BiasedDie"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BiasedDie",
            dependencies: []),
        .testTarget(
            name: "BiasedDieTests",
            dependencies: ["BiasedDie"]),
    ]
)
