// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISimulator",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "SwiftUISimulator", targets: ["SwiftUISimulator"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SwiftUISimulator", dependencies: []),
        .testTarget(name: "SwiftUISimulatorTests", dependencies: ["SwiftUISimulator"]),
    ]
)
