//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

internal let storageKeyPrefix = "YusukeHosonuma/SwiftUI-Simulator"

//
// SimulatorView
//
public struct SimulatorView<Content: View>: View {
    @AppStorage("\(storageKeyPrefix).locale")
    private var locale: String = "en_US"

    //
    // ☑️ `DynamicTypeSize` is supported in iOS 15+.
    //
    @AppStorage("\(storageKeyPrefix).dynamicTypeSize")
    private var dynamicTypeSize: DynamicTypeSizeWrapper = .medium

    @AppStorage("\(storageKeyPrefix).isDynamicTypeSizesEnabled")
    private var isDynamicTypeSizesEnabled = false

    @AppStorage("\(storageKeyPrefix).isDark")
    private var isDark = false

    @AppStorage("\(storageKeyPrefix).isDisplayInformation")
    private var isDisplayInformation = true

    @AppStorage("\(storageKeyPrefix).isDisplaySafeArea")
    private var isDisplaySafeArea = true

    @AppStorage("\(storageKeyPrefix).isSimulatorEnabled")
    private var isSimulatorEnabled = true

    @AppStorage("\(storageKeyPrefix).calendar")
    private var calendar: Calendar.Identifier = .iso8601

    @AppStorage("\(storageKeyPrefix).isDualMode")
    private var isDualMode = false

    @AppStorage("\(storageKeyPrefix).isPortrait")
    private var isPortrait = true

    @AppStorage("\(storageKeyPrefix).isDisplayCheetSheet")
    private var isDisplayCheetSheet = false

    @AppStorage("\(storageKeyPrefix).isHiddenControl")
    private var isHiddenControl = false

    //
    // 💡 Note: save and restore by code.
    //
    @ObservedObject
    private var userPreferences: UserPreferences

    //
    // Sheets
    //
    @State private var isPresentedDeviceSelectSheet = false
    @State private var isPresentedLocaleSelectSheet = false
    @State private var isPresentedCalendarSelectSheet = false

    //
    // Environments
    //
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let content: () -> Content

    public init(
        defaultDevices: Set<Device>? = nil,
        defaultLocaleIdentifiers: Set<String>? = nil,
        defaultCalendarIdentifiers: Set<Calendar.Identifier>? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content
        userPreferences = UserPreferences(
            defaultDevices: defaultDevices,
            defaultLocaleIdentifiers: defaultLocaleIdentifiers,
            defaultCalendarIdentifiers: defaultCalendarIdentifiers
        )
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
            DeviceSelectView(selectedDevices: $userPreferences.enableDevices)
        }
        //
        // Select locale sheet.
        //
        .sheet(isPresented: $isPresentedLocaleSelectSheet) {
            MultiItemSelectView(
                title: "Select locales",
                selectedItems: $userPreferences.enableLocales,
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
            MultiItemSelectView(
                title: "Select calendars",
                selectedItems: $userPreferences.enableCalendars,
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
            ZStack(alignment: .bottomTrailing) {
                //
                // Content
                //
                if let device = userPreferences.device {
                    Group {
                        if isDualMode {
                            if isPortrait {
                                HStack(spacing: 24) {
                                    simulatedContent(device: device, colorScheme: .dark, orientation: orientation)
                                    simulatedContent(device: device, colorScheme: .light, orientation: orientation)
                                }
                            } else {
                                VStack(spacing: 64) {
                                    simulatedContent(device: device, colorScheme: .dark, orientation: orientation)
                                    simulatedContent(device: device, colorScheme: .light, orientation: orientation)
                                }
                            }
                        } else {
                            simulatedContent(device: device, colorScheme: isDark ? .dark : .light, orientation: orientation)
                        }
                    }
                    .offset(y: -32)
                    .animation(.default, value: device)
                    .frame(width: reader.size.width, height: reader.size.height + reader.safeAreaInsets.bottom)
                } else {
                    content()
                        .overrideEnvironments(
                            sizeClasses: nil, // ☑️ Use real device size classes.
                            locale: locale,
                            colorScheme: isDark ? .dark : .light,
                            calendar: calendar,
                            dynamicTypeSize: dynamicTypeSize
                        )
                }

                //
                // Controls
                //
                VStack(alignment: .trailing, spacing: 0) {
                    if horizontalSizeClass == .regular {
                        ZStack(alignment: .bottomTrailing) {
                            //
                            // Device select
                            //
                            deviceSelectControl()
                                .offset(x: isHiddenControl ? 50 : 0)
                                .animation(.easeInOut(duration: 0.15), value: isHiddenControl)

                            //
                            // Cheet sheets
                            //
                            cheetSheetOvelay()
                                .animation(.easeInOut(duration: 0.15), value: isHiddenControl)
                                .animation(.easeInOut(duration: 0.15), value: isDisplayCheetSheet)
                        }
                    }

                    //
                    // Toolbar
                    //
                    simulatorToolBar(realDeviceSize: reader.size, orientation: orientation)
                        .padding(.bottom, reader.safeAreaInsets.bottom)
                        .background(Color.toolbarBackground)
                        //
                        // ☑️ Prevent layout bug during animation at iPhone XS (iOS 15.4) real device.
                        //
                        .frame(height: 44 + reader.safeAreaInsets.bottom)
                        .offset(y: isHiddenControl ? 100 : 0)
                        .animation(.easeInOut(duration: 0.15), value: isHiddenControl)
                }

                //
                // 􀁱 / 􀁯 Toggle Control
                //
                Button {
                    isHiddenControl.toggle()
                } label: {
                    Icon(isHiddenControl ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                }
                .offset(y: -reader.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func deviceSelectControl() -> some View {
        VStack(spacing: 0) {
            //
            // 􀃿
            //
            Button {
                if let prev = prevDevice() {
                    userPreferences.device = prev
                }
            } label: {
                Icon("chevron.up.square.fill")
            }
            .disabled(prevDevice() == nil)

            //
            // 􀄁
            //
            Button {
                if let next = nextDevice() {
                    userPreferences.device = next
                }
            } label: {
                Icon("chevron.down.square.fill")
            }
            .disabled(nextDevice() == nil)
        }
    }

    private func prevDevice() -> Device? {
        guard let device = userPreferences.device else { return nil }
        return userPreferences.enableDevices.sorted().prev(device)
    }

    private func nextDevice() -> Device? {
        guard let device = userPreferences.device else { return nil }
        return userPreferences.enableDevices.sorted().next(device)
    }

    private func cheetSheetOvelay() -> some View {
        HStack(alignment: .top) {
            let isDisplay = isDisplayCheetSheet && isHiddenControl == false

            textSampleView()
                .frame(width: 220)
                .offset(x: isDisplay ? 0 : -220)

            Spacer()

            colorSampleView()
                .frame(width: 220)
                .offset(x: isDisplay ? 0 : +220)
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
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
        let spacing: CGFloat? = horizontalSizeClass == .compact ? 0 : nil

        HStack(spacing: spacing) {
            HStack(spacing: spacing) {
                //
                // 􀣌 Setting menu
                //
                settingMenu()

                if horizontalSizeClass == .regular {
                    //
                    // 􀕹 Cheet sheets
                    //
                    Button {
                        isDisplayCheetSheet.toggle()
                    } label: {
                        Icon("doc.text.magnifyingglass")
                    }
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
                    .frame(maxWidth: 200)
                }
            }
            //
            // ☑️ Prevent layout bug during animation at iPhone XS (iOS 15.4) real device.
            //
            .frame(height: 44)

            Spacer()

            HStack(spacing: spacing) {
                if horizontalSizeClass == .regular {
                    //
                    // 􀏠 Dual mode
                    //
                    Button {
                        isDualMode.toggle()
                    } label: {
                        Icon(isDualMode ? "rectangle.portrait.on.rectangle.portrait.slash" : "rectangle.portrait.on.rectangle.portrait")
                    }
                }

                //
                // 􀉉 Calendar
                //
                Menu {
                    Picker(selection: $calendar) {
                        ForEach(Array(userPreferences.enableCalendars.sorted().reversed())) { identifier in
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
                        ForEach(Array(userPreferences.enableLocales.sorted().reversed()), id: \.self) { identifier in
                            Text(identifier).tag(identifier)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("a.circle")
                }

                if horizontalSizeClass == .regular {
                    //
                    // 􀎮 / 􀎰 Rotate
                    //
                    Button {
                        isPortrait.toggle()
                    } label: {
                        Icon(isPortrait ? "rotate.left" : "rotate.right")
                    }
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
                    Picker(selection: $userPreferences.device) {
                        let devices = userPreferences.enableDevices.sorted().reversed()
                        let deviceGroup = Dictionary(grouping: devices, by: \.type)

                        //
                        // Real device
                        //
                        Text("Default")
                            .tagDevice(nil)

                        Divider() // ----

                        // e.g.
                        //
                        // - iPod
                        // - iPhones
                        // - iPads
                        //
                        ForEach(deviceGroup.sorted(by: { $0.key.rawValue > $1.key.rawValue }), id: \.key.rawValue) { _, dx in
                            ForEach(dx, id: \.name) { device in
                                Text(device.name)
                                    .tagDevice(device)
                            }
                            Divider() // ----
                        }

                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("iphone")
                }
                .padding(.trailing, 44) // 💡 Space for toggle toolbar icon.
            }
            //
            // ☑️ Prevent layout bug during animation at iPhone XS (iOS 15.4) real device.
            //
            .frame(height: 44)
        }
        .padding(2)
        .border(.toolbarBorder, width: 1, edge: .top)
    }

    @ViewBuilder
    private func simulatedContent(device: Device, colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
        let width = isDisplaySafeArea
            ? device.size(orientation: orientation).width
            : device.safeArea(orientation: orientation).contentSize.width

        VStack(spacing: 0) {
            //
            // Header: e.g. "iPhone SE (3rd) (4.7 inch)" and "375 x 667"
            //
            if isDisplayInformation {
                let deviceSize = device.size(orientation: orientation)
                HStack {
                    Text("\(device.name) (\(device.inch) inch)")
                    Spacer()
                    Text("\(Int(deviceSize.width)) x \(Int(deviceSize.height))")
                }
                .foregroundColor(.info)
                .font(.caption)
            }

            //
            // Content
            //
            simulatedScreen(device: device, colorScheme: colorScheme, orientation: orientation)

            //
            // Footer: e.g. "xSmall" and "ja_JP / iso8601"
            //
            if isDisplayInformation {
                HStack {
                    if isDynamicTypeSizesEnabled {
                        Text(dynamicTypeSize.label)
                    }
                    Spacer()
                    Text("\(locale) / \(calendar.rawValue)")
                }
                .foregroundColor(.info)
                .font(.caption)
            }
        }
        .frame(width: width)
    }

    @ViewBuilder
    private func simulatedScreen(device: Device, colorScheme: ColorScheme, orientation: DeviceOrientation) -> some View {
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
        .overrideEnvironments(
            sizeClasses: sizeClass,
            locale: locale,
            colorScheme: colorScheme,
            calendar: calendar,
            dynamicTypeSize: dynamicTypeSize
        )
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
}

private extension View {
    func tagDevice(_ value: Device?) -> some View {
        tag(value)
    }

    func overrideEnvironments(
        sizeClasses: SizeClasses?,
        locale: String,
        colorScheme: ColorScheme,
        calendar: Calendar.Identifier,
        dynamicTypeSize: DynamicTypeSizeWrapper?
    ) -> some View {
        environment(\.locale, .init(identifier: locale))
            .environment(\.colorScheme, colorScheme)
            .environment(\.calendar, Calendar(identifier: calendar))
            .whenLet(sizeClasses) { content, sizeClasses in
                content
                    .environment(\.horizontalSizeClass, sizeClasses.width)
                    .environment(\.verticalSizeClass, sizeClasses.height)
            }
            .whenLet(dynamicTypeSize) {
                if #available(iOS 15, *) {
                    $0.environment(\.dynamicTypeSize, $1.nativeValue)
                } else {
                    $0
                }
            }
    }
}
