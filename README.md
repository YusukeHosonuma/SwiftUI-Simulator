# SwiftUI-Simulator

Enables the following settings without settings or restarting the simulator or real device.

- Any device screen
- Light/Dark mode
- Locale
- Calendar
- Dynamic Type Sizes
- Rotate

https://user-images.githubusercontent.com/2990285/163325330-13297947-7222-4cf7-a80b-d999094546d9.mov

No more restarting or settings.

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

<img width="400" alt="image" src="https://user-images.githubusercontent.com/2990285/163323260-8e3955d2-185e-4e0e-a074-3cf2d2db743e.png">


## Requirements

- iOS 14+ (Currently supports iPad only)
  - `Dynamic Type Sizes` is supports in iOS 15+

## Limitation

This OSS supports **SwiftUI app** only.<br>
For example, it may not work if you have resolve `locale` by yourself.

## Contributions

Issues and PRs are welcome, even for minor improvements and corrections.

## Author

Yusuke Hosonuma / [@tobi462](https://twitter.com/tobi462)
