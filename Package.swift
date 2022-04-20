// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISimulator",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "SwiftUISimulator", targets: ["SwiftUISimulator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "6.2.0"),
    ],
    targets: [
        .target(name: "SwiftUISimulator", dependencies: [
            "Defaults",
        ]),
        .testTarget(name: "SwiftUISimulatorTests", dependencies: ["SwiftUISimulator"]),
    ]
)
