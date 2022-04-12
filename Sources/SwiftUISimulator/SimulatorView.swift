//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

public struct SimulatorView<Content: View>: View {
    @AppStorage("SwiftUI-Simulator.device")
    private var device: Device = .iPhoneSE

    @AppStorage("SwiftUI-Simulator.locale")
    private var locale: String = "en_US"

    @available(iOS 15, *)
    @AppStorage("SwiftUI-Simulator.dynamicTypeSize")
    private var dynamicTypeSize: DynamicTypeSize = .medium

    @AppStorage("SwiftUI-Simulator.isDynamicTypeSizesEnabled")
    private var isDynamicTypeSizesEnabled = false

    @AppStorage("SwiftUI-Simulator.isDark")
    private var isDark = false

    @AppStorage("SwiftUI-Simulator.isDisplayInformation")
    private var isDisplayInformation = true

    @AppStorage("SwiftUI-Simulator.isDisplaySafeArea")
    private var isDisplaySafeArea = true

    @AppStorage("SwiftUI-Simulator.isSimulatorEnabled")
    private var isSimulatorEnabled = true

    @AppStorage("SwiftUI-Simulator.calendar")
    private var calendar: Calendar.Identifier = .iso8601

    @AppStorage("SwiftUI-Simulator.isDualMode")
    private var isDualMode = false

    @AppStorage("SwiftUI-Simulator.isPortrait")
    private var isPortrait = true

    //
    // 💡 Note: save and restore by code.
    //
    @State private var enableDevices: Set<Device>
    @State private var enableLocales: Set<String>
    @State private var enableCalendars: Set<Calendar.Identifier>

    private func saveEnableDevices() {
        let rawValues = Array(enableDevices.map(\.rawValue)) // TODO: change string to safe.
        UserDefaults.standard.set(rawValues, forKey: "SwiftUI-Simulator.enableDevices")
    }

    private static func loadEnableDevices() -> Set<Device> {
        if let rawValues = UserDefaults.standard.array(forKey: "SwiftUI-Simulator.enableDevices") as? [Int] {
            return Set(rawValues.compactMap(Device.init))
        } else {
            return Set(Device.allCases)
        }
    }

    private func saveEnableLocales() {
        UserDefaults.standard.set(Array(enableLocales), forKey: "SwiftUI-Simulator.enableLocales")
    }

    private static func loadEnableLocales() -> Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: "SwiftUI-Simulator.enableLocales") ?? ["en_US", "ja_JP"])
    }

    private func saveEnableCalendars() {
        UserDefaults.standard.set(Array(enableCalendars.map(\.rawValue)), forKey: "SwiftUI-Simulator.enableCalendars")
    }

    private static func loadEnableCalendars() -> Set<Calendar.Identifier> {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "SwiftUI-Simulator.enableCalendars") {
            return Set(rawValues.compactMap(Calendar.Identifier.init))
        } else {
            return Set([.iso8601, .japanese])
        }
    }
    
    //
    // Sheets
    //
    @State private var isPresentedDeviceSelectSheet = false
    @State private var isPresentedLocaleSelectSheet = false
    @State private var isPresentedCalendarSelectSheet = false

    private let content: () -> Content

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        enableDevices = Self.loadEnableDevices()
        enableLocales = Self.loadEnableLocales()
        enableCalendars = Self.loadEnableCalendars()
    }

    public var body: some View {
        GeometryReader { reader in
            VStack {
                Group {
                    if isSimulatorEnabled {
                        simulatorContainer(deviceSize: reader.size)
                    } else {
                        simulatorIcon()
                    }
                }
                .background(Color.white)
            }
        }
    }

    @ViewBuilder
    private func simulatorIcon() -> some View {
        ZStack(alignment: .bottomLeading) {
            content()

            //
            // 􀷄
            //
            Button {
                isSimulatorEnabled.toggle()
            } label: {
                Icon("power.circle.fill")
            }
        }
    }

    private func settingMenu() -> some View {
        Menu {
            //
            // 􀆨
            //
            Button {
                isSimulatorEnabled.toggle()
            } label: {
                Label("Disable simulator", systemImage: "power")
            }

            Divider() // --------

            //
            // 􀉉 Locale select
            //
            Button {
                isPresentedCalendarSelectSheet.toggle()
            } label: {
                Label("Select calendars", systemImage: "calendar")
            }

            //
            // 􀆪 Locale select
            //
            Button {
                isPresentedLocaleSelectSheet.toggle()
            } label: {
                Label("Select locales", systemImage: "globe")
            }

            //
            // 􀟜 Device select
            //
            Button {
                isPresentedDeviceSelectSheet.toggle()
            } label: {
                Label("Select devices", systemImage: "iphone")
            }

            Divider() // --------

            //
            // 􀂔
            //
            Toggle(isOn: $isDynamicTypeSizesEnabled) {
                Label("Dynamic Type Sizes", systemImage: "a.square")
            }
            //
            // 􀪛
            //
            Toggle(isOn: $isDisplaySafeArea) {
                Label("Safe Area", systemImage: "square.tophalf.filled")
            }
            //
            // 􀅴
            //
            Toggle(isOn: $isDisplayInformation) {
                Label("Information", systemImage: "info.circle")
            }
        } label: {
            //
            // 􀣌
            //
            Icon("gearshape.fill")
        }
        //
        // Select device sheet.
        //
        .sheet(isPresented: $isPresentedDeviceSelectSheet) {
            saveEnableDevices()
        } content: {
            DeviceSelectView(selectedDevices: $enableDevices)
        }
        //
        // Select locale sheet.
        //
        .sheet(isPresented: $isPresentedLocaleSelectSheet) {
            saveEnableLocales()
        } content: {
            MultiItemSelectView(
                title: "Select locales",
                selectedItems: $enableLocales,
                allItems: Locale.availableIdentifiers.filter { $0.contains("_") }.sorted(),
                allowNoSelected: false
            ) {
                Text($0)
            }
        }
        //
        // Select calendar sheet.
        //
        .sheet(isPresented: $isPresentedCalendarSelectSheet) {
            saveEnableCalendars()
        } content: {
            MultiItemSelectView(
                title: "Select calendars",
                selectedItems: $enableCalendars,
                allItems: Calendar.Identifier.allCases,
                allowNoSelected: false
            ) {
                Text($0.rawValue)
            }
        }
    }

    @ViewBuilder
    private func simulatorContainer(deviceSize: CGSize) -> some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                let orientation: DeviceOrientation = isPortrait ? .portrait : .landscape
                if isDualMode {
                    if isPortrait {
                        HStack(spacing: 24) {
                            simulatedContent(colorScheme: .dark, orientation: orientation)
                            simulatedContent(colorScheme: .light, orientation: orientation)
                        }
                    } else {
                        VStack(spacing: 64) {
                            simulatedContent(colorScheme: .dark, orientation: orientation)
                            simulatedContent(colorScheme: .light, orientation: orientation)
                        }
                    }
                } else {
                    simulatedContent(colorScheme: isDark ? .dark : .light, orientation: orientation)
                }
            }
            .offset(y: -32)
            .animation(.default, value: device)
            .frame(width: deviceSize.width, height: deviceSize.height)
            .frame(maxWidth: .infinity, maxHeight: deviceSize.height)

            HStack(alignment: .center) {
                //
                // 􀣌 Setting menu
                //
                settingMenu()
                    .padding(.trailing, 16)

                //
                // 􀀅 Dynamic Type Sizes slider
                //
                if #available(iOS 15, *), isDynamicTypeSizesEnabled {
                    Slider(
                        value: $dynamicTypeSize.sliderBinding(),
                        in: DynamicTypeSize.sliderRange,
                        step: 1
                    )
                    .frame(width: 200)
                }

                Spacer()

                //
                // 􀎮 Rotate
                //
                Button {
                    isPortrait.toggle()
                } label: {
                    Icon("rotate.left")
                }
                .padding(.trailing, 4)

                //
                // 􀏠 Dual mode
                //
                Button {
                    isDualMode.toggle()
                } label: {
                    Icon("square.split.2x1")
                }
                .padding(.trailing, 4)

                //
                // 􀟝 Device
                //
                Menu {
                    Picker(selection: $device) {
                        let devices = isPortrait
                            ? enableDevices.filter { $0.size.width < deviceSize.width && $0.size.height < deviceSize.height }
                            : enableDevices.filter { $0.size.height < deviceSize.width && $0.size.width < deviceSize.height }

                        ForEach(Array(devices.sorted().reversed()), id: \.name) { device in
                            Text(device.name)
                                .tag(device)
                            // 😇 `disabled` are not working. (I have no choice but to deal with it by filtering)
                            // https://www.hackingwithswift.com/forums/swiftui/disabling-items-in-a-menu-picker/6992
                            // .disabled(deviceSize.width < device.size.width || deviceSize.height < device.size.height)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("iphone")
                }
                .padding(.trailing, 4)

                //
                // 􀀂 Light / Dark
                //
                Button {
                    isDark.toggle()
                } label: {
                    if isDark {
                        Icon("moon")
                    } else {
                        Icon("sun.max")
                    }
                }
                .padding(.trailing, 4)
                .disabled(isDualMode == true)

                //
                // 􀫖 Locale
                //
                Menu {
                    Picker(selection: $locale) {
                        ForEach(Array(enableLocales.sorted()), id: \.self) { identifier in
                            Text(identifier).tag(identifier)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("a.circle")
                }
                .padding(.trailing, 4)

                //
                // 􀉉 Calendar
                //
                Menu {
                    Picker(selection: $calendar) {
                        ForEach(Array(enableCalendars)) { identifier in
                            Text(identifier.id).tag(identifier)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("calendar")
                }
            }
            .padding()
            .frame(width: deviceSize.width, height: 64)
            .background(Color(red: 220, green: 220, blue: 220))
        }
    }

    @ViewBuilder
    private func simulatedContent(colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let safeAreaHeight = device.safeAreaTop + device.safeAreaBottom
        let fw = device.size.width
        let fh = device.size.height - (isDisplaySafeArea ? 0 : safeAreaHeight)
        let (frameWidth, _) = orientation == .portrait ? (fw, fh) : (fh, fw)

        let w = device.size.width
        let h = device.size.height - safeAreaHeight
        let (width, height) = orientation == .portrait ? (w, h) : (h, w)

        ZStack(alignment: .topLeading) {
            ZStack(alignment: .bottomLeading) {
                appContent(width: width, height: height, colorScheme: colorScheme, orientation: orientation)

                if isDisplayInformation {
                    footer()
                        .offset(y: 24)
                        .frame(width: frameWidth)
                }
            }

            if isDisplayInformation {
                header()
                    .offset(y: -24)
                    .frame(width: frameWidth)
            }
        }
    }

    private func appContent(width: CGFloat, height: CGFloat, colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        Group {
            let appContent = content().frame(width: width, height: height, alignment: .center)

            if orientation == .portrait {
                VStack(spacing: 0) {
                    if isDisplaySafeArea {
                        Color.pink.opacity(0.1)
                            .frame(height: device.safeAreaTop)
                    }

                    appContent

                    if isDisplaySafeArea {
                        Color.pink.opacity(0.1)
                            .frame(height: device.safeAreaBottom)
                    }
                }
                .frame(width: width)
            } else {
                HStack(spacing: 0) {
                    if isDisplaySafeArea {
                        Color.pink.opacity(0.1)
                            .frame(width: device.safeAreaTop)
                    }

                    appContent

                    if isDisplaySafeArea {
                        Color.pink.opacity(0.1)
                            .frame(width: device.safeAreaBottom)
                    }
                }
                .frame(height: height)
            }
        }
        .border(.blue)
        .environment(\.verticalSizeClass, orientation == .portrait ? device.portraitSizeClass.height : device.landscapeSizeClass.height)
        .environment(\.horizontalSizeClass, orientation == .portrait ? device.portraitSizeClass.width : device.landscapeSizeClass.width)
        .environment(\.locale, .init(identifier: locale))
        .environment(\.colorScheme, colorScheme)
        .environment(\.calendar, Calendar(identifier: calendar))
        .when(isDynamicTypeSizesEnabled) {
            if #available(iOS 15, *) {
                $0.environment(\.dynamicTypeSize, dynamicTypeSize)
            } else {
                $0
            }
        }
    }

    @ViewBuilder
    private func header() -> some View {
        let w = Int(device.size.width)
        let h = Int(device.size.height)
        HStack {
            Text("\(device.name) - \(device.inch) inch (\(w) x \(h))")
            Spacer()
        }
        .foregroundColor(.gray)
    }

    @ViewBuilder
    private func footer() -> some View {
        HStack {
            if #available(iOS 15, *), isDynamicTypeSizesEnabled {
                Text(dynamicTypeSize.label)
            }
            Spacer()
            Text("\(locale) / \(calendar.rawValue)")
        }
        .foregroundColor(.gray)
    }
}
