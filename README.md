# SwiftUI-Simulator

Enables the following settings without settings or restarting the simulator or real device.

- [x] Any device screen
- [x] Light/Dark mode
- [x] Locale
- [x] Calendar
- [x] TimeZone
- [x] Dynamic Type Sizes
- [x] Rotate
- [ ] ~~Legibility Weight (Not working in latest iOS and Xcode preview)~~

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
        .package(url: "https://github.com/YusukeHosonuma/SwiftUI-Simulator.git", from: "1.3.0"),
    ],
    targets: [
        .target(name: "<your-target-name>", dependencies: [
             .product(name: "SwiftUISimulator", package: "SwiftUI-Simulator"),
        ]),
    ]
)
```

2. Surround the your app's root view with `SimulatorView`.

```swift
import SwiftUISimulator

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SimulatorView { // ✅ Please surround the your app's root view with `SimulatorView`.
                ContentView()
            }
        }
    }
}
```

3. Launch on any simulator or device. (Large screen is recommended)

| iPhone 13 Pro Max | iPad Pro (12.9-inch) |
|--|--|
|<img width="356" alt="image" src="https://user-images.githubusercontent.com/2990285/163754076-46be83af-f220-4009-8228-bcd64d34a0ab.png">|<img width="651" alt="image" src="https://user-images.githubusercontent.com/2990285/163754087-cd4ce210-6698-4b47-a969-d1a129c239ca.png">|


## Requirements

- iOS 14+ (iPhone / iPad)
  - `Dynamic Type Sizes` is supports in iOS 15+

## Limitation

- This OSS supports **SwiftUI app** only.<br>
  - For example, it may not work if you have resolve `locale` by yourself. (e.g. use [SwiftGen](https://github.com/SwiftGen/SwiftGen))
- `sheet()` and `fullScreenCover()` are not working currently. [#37](https://github.com/YusukeHosonuma/SwiftUI-Simulator/issues/37)

## Configurations

You can specify default `devices`, `locale identifiers`, `calendar identifiers` and `timezone`.

```swift
SimulatorView(
    defaultDevices: [.iPhone11, .iPhone13ProMax],       // Set<Device>
    defaultLocaleIdentifiers: ["it", "fr"],             // Set<String>
    defaultCalendarIdentifiers: [.gregorian, .iso8601], // Set<Calendar.Identifier>
    defaultTimeZones: [.europeParis, .europeBerlin]     // Set<TimeZones>
    accentColorName: "MyAccentColor",                   // when not use default accent color name in Assets.
) {
    RootView()
}
```
This is useful if you want to share with your team.

## Contributions

Issues and PRs are welcome, even for minor improvements and corrections.

## FAQ

Q. How it works?<br>
A. Perhaps as you might imagine, this is achieved by overriding SwiftUI's [Environment](https://developer.apple.com/documentation/swiftui/environment).

Q. How to disable this simulator?<br>
A. `Disable Simulator` in setting menu.

<img width="205" alt="image" src="https://user-images.githubusercontent.com/2990285/164544318-18b2f547-44ef-46da-8a29-6744d1c27990.png">

## Author

Yusuke Hosonuma / [@tobi462](https://twitter.com/tobi462)
