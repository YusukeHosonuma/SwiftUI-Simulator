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
        .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", from: "1.2.0"),
        .package(url: "https://github.com/YusukeHosonuma/UserDefaultsBrowser.git", branch: "main"),
    ],
    targets: [
        .target(name: "SwiftUISimulator", dependencies: [
            "Defaults",
            "SwiftPrettyPrint", // TODO: can remove?
            "UserDefaultsBrowser",
        ]),
        .testTarget(name: "SwiftUISimulatorTests", dependencies: ["SwiftUISimulator"]),
    ]
)
