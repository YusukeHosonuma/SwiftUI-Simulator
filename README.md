# SwiftUI-Simulator

Simulate device configurations in real-time. (and useful tools for development)

https://user-images.githubusercontent.com/2990285/163325330-13297947-7222-4cf7-a80b-d999094546d9.mov

## Feature

### Simulation

- [x] Any device screen
- [x] Light/Dark mode
- [x] Locale
- [x] Calendar
- [x] TimeZone
- [x] Dynamic Type Sizes (iOS 15+)
- [x] Rotate
- [ ] ~~Legibility Weight (Not working in latest iOS and Xcode preview)~~

**Note: This is only a simulation and may differ from how it looks on a simulator or real device.**

### UserDefaults browser

You can browse UserDefaults on simulator.

<img width="600" alt="image" src="https://user-images.githubusercontent.com/2990285/166129997-1211925c-504e-40c1-9578-d8a9975d70b7.png">

## Quick Start

1. Install via Swift Package Manager.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/SwiftUI-Simulator.git", from: "1.4.0"),
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
#if DEBUG
import SwiftUISimulator
#endif

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView { // ✅ Please surround the your app's root view with `SimulatorView`.
                ContentView()
            }
            #else
            ContentView()
            #endif
        }
    }
}
```

3. Launch on any simulator or device. (Large screen is recommended)

| iPhone 13 Pro Max | iPad Pro (12.9-inch) |
|--|--|
|<img width="250" alt="image" src="https://user-images.githubusercontent.com/2990285/163754076-46be83af-f220-4009-8228-bcd64d34a0ab.png">|<img width="400" alt="image" src="https://user-images.githubusercontent.com/2990285/163754087-cd4ce210-6698-4b47-a969-d1a129c239ca.png">|


## Requirements

- iOS 14+ (iPhone / iPad)
  - `Dynamic Type Sizes` is supports in iOS 15+

## Limitation

- This OSS supports **SwiftUI app** only.<br>
  - For example, it may not work if you have resolve `locale` by yourself. (e.g. use [SwiftGen](https://github.com/SwiftGen/SwiftGen))
- `sheet()` and `fullScreenCover()` are not working currently. [#37](https://github.com/YusukeHosonuma/SwiftUI-Simulator/issues/37)

## Custom Debug Menu

You can add custom debug menu.

```swift
SimulatorView {
    // 💡 Add custom debug menu.
    Button {
        print("Hello!")
    } label: {
        Label("Custom Debug", systemImage: "ant.circle")
    }
} content: {
    ContentView()
}
```

This makes it easy to run custom debug action.

<img width="267" alt="image" src="https://user-images.githubusercontent.com/2990285/165664233-758912e1-2aa3-4028-b1a0-43182329d02f.png">

## Built-in Modifier (Experimental)

As a built-in, we provide a modifier that displays the file name of the View.

| Debug enabled | Debug disabled |
| -- | -- |
| <img width="300" alt="image" src="https://user-images.githubusercontent.com/2990285/165674830-b4167811-162c-4d9b-985c-eb8a22ff83e5.png"> | <img width="300" alt="image" src="https://user-images.githubusercontent.com/2990285/165674861-1b473561-c164-4d5e-8bb1-8a7bf77780a1.png"> |

The installation procedure is as follows. (recommended)

1. Add `View+Debug.swift`.

```swift
import SwiftUI

#if DEBUG
import SwiftUISimulator
#endif

public extension View {
    func debugFilename(_ file: StaticString = #file) -> some View {
        // ✅ Enabled when debug build only.
        #if DEBUG
        simulatorDebugFilename(file) // 💡 or any `String`.
        #else
        self
        #endif
    }
}
```

2. Add custom debug menu and environment.

```swift
struct ExampleApp: App {
    //
    // ✅ To show/hide
    //
    #if DEBUG
    @State private var isEnabledDebugFilename = false
    #endif

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView {
                //
                // ✅ Add debug menu.
                //
                Menu {
                    Toggle(isOn: $isEnabledDebugFilename) {
                        Label("Filename", systemImage: "doc.text.magnifyingglass")
                    }
                } label: {
                    Label("Debug", systemImage: "ant.circle")
                }
            } content: {
                RootView()
                    //
                    // ✅ Add `simulatorDebugFilename` environment value to root view.
                    //
                    .environment(\.simulatorDebugFilename, isEnabledDebugFilename)
            }
            #else
            ContentView()
            #endif
        }
    }
}
```

3. Add `debugFilename()` modifier to any views. (where you needed)

```swift
struct FooView: View {
    var body: some View {
        Text("Foo")
            .debugFilename() // ✅
    }
}
```

Note:  
As you can probably imagine, it is easy to make this yourself.
Please refer to [DebugFilenameModifier.swift)](https://github.com/YusukeHosonuma/SwiftUI-Simulator/blob/main/Sources/SwiftUISimulator/DebugFilenameModifier.swift).

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
