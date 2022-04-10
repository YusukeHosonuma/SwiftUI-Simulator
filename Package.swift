// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUI-Simulator",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(name: "SwiftUI-Simulator", targets: ["SwiftUI-Simulator"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SwiftUI-Simulator", dependencies: []),
        .testTarget(name: "SwiftUI-SimulatorTests", dependencies: ["SwiftUI-Simulator"]),
    ]
)
