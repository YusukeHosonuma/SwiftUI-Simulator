# SwiftUI-Simulator

Enables the following settings without settings or restarting the simulator or real device.

- Any device screen
- Light/Dark mode
- Locale
- Calendar
- Dynamic Type Sizes
- Rotate

https://user-images.githubusercontent.com/2990285/163325330-13297947-7222-4cf7-a80b-d999094546d9.mov

No more restarting or settings!

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
            SimulatorView { // ✅ Please surround the root view with `SimulatorView`.
                RootView()
            }
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
For example, it may not work if you have resolve `locale` by yourself. (e.g. use [SwiftGen](https://github.com/SwiftGen/SwiftGen))

## Configurations

You can specify default `devices`, `locale identifiers` and `calendar identifiers`.

```swift
SimulatorView(
    defaultDevices: [.iPhone11, .iPhone13ProMax],      // Set<Device>
    defaultLocaleIdentifiers: ["it", "fr"],            // Set<String>
    defaultCalendarIdentifiers: [.gregorian, .iso8601] // Set<Calendar.Identifier>
) {
    RootView()
}
```
This is useful if you want to share with your team.

## Contributions

Issues and PRs are welcome, even for minor improvements and corrections.

## FAQ

Q. How to disable this simulator?<br>
A. `Disable simulator` on setting menu.

<img width="186" alt="image" src="https://user-images.githubusercontent.com/2990285/163336996-16864267-5a01-446b-afe8-33b613be671d.png">

Q. How it works?<br>
A. Perhaps as you might imagine, this is achieved by overriding SwiftUI's [Environment](https://developer.apple.com/documentation/swiftui/environment).

## Author

Yusuke Hosonuma / [@tobi462](https://twitter.com/tobi462)
