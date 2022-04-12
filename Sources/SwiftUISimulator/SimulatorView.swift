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
                        simulatorContainer(realDeviceSize: reader.size)
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
    private func simulatorContainer(realDeviceSize: CGSize) -> some View {
        let orientation: DeviceOrientation = isPortrait ? .portrait : .landscape
        ZStack(alignment: .bottomLeading) {
            Group {
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
            .frame(width: realDeviceSize.width, height: realDeviceSize.height)
            .frame(maxWidth: .infinity, maxHeight: realDeviceSize.height)

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
                        let devices = enableDevices
                            .filter {
                                let size = $0.size(orientation: orientation)
                                return size.width < realDeviceSize.width && size.height < realDeviceSize.height
                            }
                            .sorted()
                            .reversed()

                        ForEach(Array(devices), id: \.name) { device in
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
                // 􀀄 Locale
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
            .frame(width: realDeviceSize.width, height: 64)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95, opacity: 1.0))
        }
    }

    @ViewBuilder
    private func simulatedContent(colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let width = device.size(orientation: orientation).width

        ZStack(alignment: .topLeading) {
            ZStack(alignment: .bottomLeading) {
                appContent(colorScheme: colorScheme, orientation: orientation)

                if isDisplayInformation {
                    footer()
                        .offset(y: 24)
                        .frame(width: width)
                }
            }

            if isDisplayInformation {
                header(orientaion: orientation)
                    .offset(y: -24)
                    .frame(width: width)
            }
        }
    }

    @ViewBuilder
    private func appContent(colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let deviceSize = device.size(orientation: orientation)
        let safeArea = device.safeArea(orientation: orientation)
        let contentSize = safeArea.contentSize
        let sizeClass = device.sizeClass(orientation: orientation)

        VStack(spacing: 0) {
            //
            // Safe area - Top
            //
            safeAreaMargin()
                .frame(height: safeArea.top)
            
            HStack(spacing: 0) {
                //
                // Safe area - Left
                //
                safeAreaMargin()
                    .frame(width: safeArea.left)
                
                //
                // Application content
                //
                content()
                    .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
                
                //
                // Safe area - Right
                //
                safeAreaMargin()
                    .frame(width: safeArea.right)
                
            }
            
            //
            // Safe area - Bottom
            //
            safeAreaMargin()
                .frame(height: safeArea.bottom)
        }
        .frame(width: deviceSize.width, height: deviceSize.height)
        .border(.blue)
        .environment(\.verticalSizeClass, sizeClass.height)
        .environment(\.horizontalSizeClass, sizeClass.width)
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
    private func safeAreaMargin() -> some View {
        if isDisplaySafeArea {
            Color.pink.opacity(0.1)
        }
    }
    
    @ViewBuilder
    private func header(orientaion: DeviceOrientation) -> some View {
        let deviceSize = device.size(orientation: orientaion)
        let w = Int(deviceSize.width)
        let h = Int(deviceSize.height)
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
