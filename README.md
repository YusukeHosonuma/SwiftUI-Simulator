# SwiftUI-Simulator

A description of this package.

## Setup

Install via Swift Package Manager.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/SwiftUI-Simulator.git", branch: "main"),
    ],
    targets: [
        .target(name: "<your-target-name>", dependencies: [
             .product(name: "SwiftUISimulator", package: "SwiftUI-Simulator"),
        ]),
    ]
)
```

Surround the root view with `SimulatorView`.

```swift
import SwiftUISimulator

@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            // ✅ Please surround the root view with `SimulatorView`.
            SimulatorView {
                ContentView()
            }
        }
    }
}
```

## Requirements

- iOS 14+
  - `Dynamic Type Sizes` is supporte in iOS 15+
