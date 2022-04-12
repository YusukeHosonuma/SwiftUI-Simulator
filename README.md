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

Wrap you root view by `SimulatorView`.

```swift
import SwiftUISimulator

@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            // ✅ Please wrap your root view by `SimulatorView`.
            #if DEBUG
            SimulatorView {
                ContentView()
            }
            #else
            ContentView()
            #endif
        }
    }
}
```

## Requirements

- iOS 15+ (currently)
