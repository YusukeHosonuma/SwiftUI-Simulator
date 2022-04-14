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

    @AppStorage("SwiftUI-Simulator.dynamicTypeSize")
    private var dynamicTypeSize: DynamicTypeSizeWrapper = .medium

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

    @AppStorage("SwiftUI-Simulator.isDisplayCheetSheet")
    private var isDisplayCheetSheet = false

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
        VStack {
            Group {
                if isSimulatorEnabled {
                    simulatorContainer()
                } else {
                    simulatorIcon()
                }
            }
            .background(Color.white)
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
            // 􀂔 Dynamic Type Size
            //
            if #available(iOS 15, *) {
                Toggle(isOn: $isDynamicTypeSizesEnabled) {
                    Label("Dynamic Type Sizes", systemImage: "a.square")
                }
            }
            
            //
            // 􀪛 Locale
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
                allowNoSelected: false,
                searchableText: { $0 }
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
                allowNoSelected: false,
                searchableText: { $0.rawValue }
            ) {
                Text($0.rawValue)
            }
        }
    }

    @ViewBuilder
    private func simulatorContainer() -> some View {
        let orientation: DeviceOrientation = isPortrait ? .portrait : .landscape
        GeometryReader { reader in
            ZStack(alignment: .bottomLeading) {
                //
                // Content
                //
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
                .frame(width: reader.size.width, height: reader.size.height + reader.safeAreaInsets.bottom)

                VStack(alignment: .trailing, spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        //
                        // Device select
                        //
                        VStack(spacing: 0) {
                            //
                            // 􀁮
                            //
                            Button {
                                if let prev = prevDevice() {
                                    device = prev
                                }
                            } label: {
                                Icon("chevron.up.circle")
                            }
                            .disabled(prevDevice() == nil)

                            //
                            // 􀁰
                            //
                            Button {
                                if let next = nextDevice() {
                                    device = next
                                }
                            } label: {
                                Icon("chevron.down.circle")
                            }
                            .disabled(nextDevice() == nil)
                        }
                        .padding(4)

                        //
                        // Cheet sheets
                        //
                        cheetSheet()
                    }

                    //
                    // Toolbar
                    //
                    simulatorToolBar(realDeviceSize: reader.size, orientation: orientation)
                        .padding(.bottom, reader.safeAreaInsets.bottom)
                        .background(Color.toolbarBackground)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func prevDevice() -> Device? {
        enableDevices.sorted().prev(device)
    }

    private func nextDevice() -> Device? {
        enableDevices.sorted().next(device)
    }

    private func cheetSheet() -> some View {
        Group {
            HStack(alignment: .top) {
                textSampleView()
                    .frame(width: 220)
                    .offset(x: isDisplayCheetSheet ? 0 : -220)

                Spacer()

                colorSampleView()
                    .frame(width: 220)
                    .offset(x: isDisplayCheetSheet ? 0 : +220)
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }

    private func textSampleView() -> some View {
        List {
            ForEach(Font.TextStyle.allCases, id: \.name) { textStyle in
                Text("\(textStyle.name)")
                    .font(.system(textStyle))
            }
        }
        .when(isDynamicTypeSizesEnabled) {
            if #available(iOS 15, *) {
                $0.environment(\.dynamicTypeSize, dynamicTypeSize.nativeValue)
            } else {
                $0
            }
        }
    }

    private func colorSampleView() -> some View {
        List {
            ForEach(Color.allCases, id: \.name) { color in
                HStack {
                    Text(color.name)
                    Spacer()
                    color.frame(width: 60)
                }
                .frame(height: 16)
            }
        }
    }

    @ViewBuilder
    private func simulatorToolBar(realDeviceSize _: CGSize, orientation _: DeviceOrientation) -> some View {
        HStack {
            HStack {
                //
                // 􀣌 Setting menu
                //
                settingMenu()

                //
                // 􀕹 Cheet sheets
                //
                Button {
                    withAnimation {
                        isDisplayCheetSheet.toggle()
                    }
                } label: {
                    Icon("doc.text.magnifyingglass")
                }

                //
                // 􀀅 Dynamic Type Sizes slider
                //
                if #available(iOS 15, *), isDynamicTypeSizesEnabled {
                    Slider(
                        value: $dynamicTypeSize.sliderBinding(),
                        in: DynamicTypeSizeWrapper.sliderRange,
                        step: 1
                    )
                    .frame(width: 200)
                }
            }

            Spacer()

            HStack {
                //
                // 􀏠 Dual mode
                //
                Button {
                    isDualMode.toggle()
                } label: {
                    Icon(isDualMode ? "rectangle.portrait.on.rectangle.portrait.slash" : "rectangle.portrait.on.rectangle.portrait")
                }

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

                //
                // 􀎮 / 􀎰 Rotate
                //
                Button {
                    isPortrait.toggle()
                } label: {
                    Icon(isPortrait ? "rotate.left" : "rotate.right")
                }

                //
                // 􀀂 Light / Dark
                //
                Button {
                    isDark.toggle()
                } label: {
                    Icon(isDark ? "sun.max" : "moon")
                }
                .disabled(isDualMode == true)

                //
                // 􀟝 Device
                //
                Menu {
                    Picker(selection: $device) {
                        let devices = enableDevices.sorted().reversed()
                        let deviceGroup = Dictionary(grouping: devices, by: \.type)

                        // e.g.
                        //
                        // - iPod
                        // - iPhones
                        // - iPads
                        //
                        ForEach(deviceGroup.sorted(by: { $0.key.rawValue > $1.key.rawValue }), id: \.key.rawValue) { _, dx in
                            ForEach(dx, id: \.name) { device in
                                Text(device.name)
                                    .tag(device)
                            }
                            Divider()
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("iphone")
                }
            }
        }
        .padding(4)
        .border(.toolbarBorder, width: 1, edge: .top)
    }

    @ViewBuilder
    private func simulatedContent(colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let width = device.size(orientation: orientation).width

        VStack(spacing: 0) {
            //
            // Header
            //
            if isDisplayInformation {
                header(orientaion: orientation)
            }

            //
            // Content
            //
            simulatedScreen(colorScheme: colorScheme, orientation: orientation)

            //
            // Footer
            //
            if isDisplayInformation {
                footer()
            }
        }
        .frame(width: width)
    }

    @ViewBuilder
    private func simulatedScreen(colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let deviceSize = device.size(orientation: orientation)
        let safeArea = device.safeArea(orientation: orientation)
        let contentSize = safeArea.contentSize
        let sizeClass = device.sizeClass(orientation: orientation)
        let frameSize = isDisplaySafeArea ? deviceSize : contentSize

        VStack(spacing: 0) {
            //
            // Safe area - Top
            //
            safeAreaMargin(.vertical, size: safeArea.top)

            HStack(spacing: 0) {
                //
                // Safe area - Left
                //
                safeAreaMargin(.horizontal, size: safeArea.left)

                //
                // Application content
                //
                content()
                    .frame(width: contentSize.width, height: contentSize.height, alignment: .center)

                //
                // Safe area - Right
                //
                safeAreaMargin(.horizontal, size: safeArea.right)
            }

            //
            // Safe area - Bottom
            //
            safeAreaMargin(.vertical, size: safeArea.bottom)
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .border(.blue)
        .environment(\.verticalSizeClass, sizeClass.height)
        .environment(\.horizontalSizeClass, sizeClass.width)
        .environment(\.locale, .init(identifier: locale))
        .environment(\.colorScheme, colorScheme)
        .environment(\.calendar, Calendar(identifier: calendar))
        .when(isDynamicTypeSizesEnabled) {
            if #available(iOS 15, *) {
                $0.environment(\.dynamicTypeSize, dynamicTypeSize.nativeValue)
            } else {
                $0
            }
        }
    }

    @ViewBuilder
    private func safeAreaMargin(_ axis: Axis, size: CGFloat) -> some View {
        if isDisplaySafeArea {
            Group {
                if isDisplayInformation {
                    Text("\(Int(size))")
                        .foregroundColor(.info)
                        .font(.system(size: 12))
                } else {
                    Color.clear
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.safeArea)
            .when(axis == .vertical) {
                $0.frame(height: size)
            }
            .when(axis == .horizontal) {
                $0.frame(width: size)
            }
        }
    }

    @ViewBuilder
    private func header(orientaion: DeviceOrientation) -> some View {
        let deviceSize = device.size(orientation: orientaion)
        let w = Int(deviceSize.width)
        let h = Int(deviceSize.height)
        HStack {
            Text("\(device.name) - \(device.inch) inch")
            Spacer()
            Text("\(w) x \(h)")
        }
        .foregroundColor(.info)
        .font(.caption)
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
        .foregroundColor(.info)
        .font(.caption)
    }
}
