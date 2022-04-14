# SwiftUI-Simulator

Enables the following settings without setting up or restarting the simulator or real device.

- Any device screen size
- Light/Dark mode
- Rotate
- Locale
- Calendar
- Dynamic Type Sizes

No more restarting or configurations!

And following:

- Show safe area and size.
- Show device information.
- Show cheet sheets. (useful for development)

**Note: This is only a simulation and may differ from how it looks on a simulator or real device.**

## Quick Start

1. Install via Swift Package Manager.

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

2. Surround the root view with `SimulatorView`.

```swift
import SwiftUISimulator

@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView { // ✅ Please surround the root view with `SimulatorView`.
                RootView()
            }
            #else
            RootView()
            #endif
        }
    }
}
```

3. Launch on any iPad. (Large screen is recommended)

<img width="713" alt="image" src="https://user-images.githubusercontent.com/2990285/163323260-8e3955d2-185e-4e0e-a074-3cf2d2db743e.png">


## Requirements

- iOS 14+ (Currently supports iPad only)
  - `Dynamic Type Sizes` is supporte in iOS 15+

## Limitation

This OSS supports **SwiftUI app** only.
For example, it may not work if you have resolve `locale` by yourself.

## Author

Yusuke Hosonuma / [@tobi462](https://twitter.com/tobi462)
