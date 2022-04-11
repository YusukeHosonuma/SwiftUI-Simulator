# SwiftUI-Simulator

A description of this package.

## Setup

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

```swift
import SwiftUISimulator

@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            // ✅ Please wrap your root view.
            SimulatorView {
                ContentView()
            }
        }
    }
}
```

## Requirements

- iOS 15+ (currently)
