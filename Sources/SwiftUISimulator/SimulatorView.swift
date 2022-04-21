//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import Defaults
import SwiftUI

internal let storageKeyPrefix = "YusukeHosonuma/SwiftUI-Simulator"

//
// SimulatorView
//
public struct SimulatorView<Content: View>: View {
    //
    // Device and Appearance
    //
    @Default(.device) private var device
    @Default(.isDark) private var isDark
    @Default(.isDualMode) private var isDualMode
    @Default(.isPortrait) private var isPortrait

    //
    // Presets
    //
    @Default(.enableDevices) private var enableDevices
    @Default(.enableLocales) private var enableLocales
    @Default(.enableCalendars) private var enableCalendars
    @Default(.enableTimeZones) private var enableTimeZones

    //
    // Fonts
    //
    @Default(.legibilityWeight) private var legibilityWeight
    @Default(.dynamicTypeSize) private var dynamicTypeSize
    @Default(.isDynamicTypeSizesEnabled) private var isDynamicTypeSizesEnabled

    //
    // International
    //
    @Default(.locale) private var locale
    @Default(.calendar) private var calendar
    @Default(.timeZone) private var timeZone

    //
    // Debug information
    //
    @Default(.isDisplayInformation) private var isDisplayInformation
    @Default(.isDisplaySafeArea) private var isDisplaySafeArea

    //
    // Simultor state
    //
    @Default(.isSimulatorEnabled) private var isSimulatorEnabled
    @Default(.isDisplayCheetSheet) private var isDisplayCheetSheet
    @Default(.isHiddenControl) private var isHiddenControl

    //
    // Sheets
    //
    @State private var isPresentedSettingSheet = false

    //
    // Environments
    //
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    //
    // Private properties
    //
    private let content: () -> Content
    private let defaultDevices: Set<Device>
    private let defaultLocales: Set<String>
    private let defaultCalendars: Set<Calendar.Identifier>
    private let defaultTimeZones: Set<TimeZones>
    private let accentColorLight: Color?
    private let accentColorDark: Color?

    //
    // Initializer
    //
    public init(
        defaultDevices userDevices: Set<Device>? = nil,
        defaultLocaleIdentifiers userLocaleIdentifiers: Set<String>? = nil,
        defaultCalendarIdentifiers userCalendarIdentifiers: Set<Calendar.Identifier>? = nil,
        defaultTimeZones userTimeZones: Set<TimeZones>? = nil,
        accentColorName: String = "AccentColor",
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content

        //
        // Presets
        //
        defaultDevices = userDevices ?? Presets.devices
        defaultLocales = userLocaleIdentifiers ?? Presets.locales
        defaultCalendars = userCalendarIdentifiers ?? Presets.calendars
        defaultTimeZones = userTimeZones ?? Presets.timeZones

        //
        // AccentColor
        //
        if let accentColor = UIColor(named: accentColorName) {
            accentColorLight = Color(accentColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)))
            accentColorDark = Color(accentColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)))
        } else {
            accentColorLight = nil
            accentColorDark = nil
        }

        //
        // 💡 The following priority order.
        //
        // 1. Saved user settings. (if not empty)
        // 2. Specified user settings on SimulatorView's initializer.
        // 3. Default presets.
        //
        if enableDevices.isEmpty {
            enableDevices = userDevices ?? Presets.devices
        }

        if enableLocales.isEmpty {
            enableLocales = userLocaleIdentifiers ?? Presets.locales
        }

        if enableCalendars.isEmpty {
            enableCalendars = userCalendarIdentifiers ?? Presets.calendars
        }

        if enableTimeZones.isEmpty {
            enableTimeZones = userTimeZones ?? Presets.timeZones
        }
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
            // 􀆨 Disable Simulator
            //
            Button {
                isSimulatorEnabled.toggle()
            } label: {
                Label("Disable Simulator", systemImage: "power")
            }
            Divider() // --------

            //
            // 􀍟 Settings
            //
            Button {
                isPresentedSettingSheet.toggle()
            } label: {
                Label("Settings", systemImage: "gear")
            }

            Divider() // --------

            Group {
                // 🚫 `legibilityWeight` is not working currently. (Same for Xcode preview)
                //
                // 􀅓 Bold Text
                //
                // Toggle("Bold Text", isOn: .init(get: {
                //     legibilityWeight == .bold
                // }, set: {
                //     legibilityWeight = $0 ? .bold : .regular
                // }))

                //
                // 􀂔 Dynamic Type Size
                //
                if #available(iOS 15, *) {
                    Toggle(isOn: $isDynamicTypeSizesEnabled) {
                        Label("Dynamic Type Sizes", systemImage: "a.square")
                    }
                }
            }

            Divider() // --------

            Group {
                //
                // 􀪛 Safe Area
                //
                Toggle(isOn: $isDisplaySafeArea) {
                    Label("Safe Area", systemImage: "square.tophalf.filled")
                }
                .disabled(device == nil)

                //
                // 􀅴
                //
                Toggle(isOn: $isDisplayInformation) {
                    Label("Information", systemImage: "info.circle")
                }
                .disabled(device == nil)
            }
        } label: {
            //
            // 􀣌
            //
            Icon("gearshape.fill")
        }
        //
        // 􀋲 Settings
        //
        .sheet(isPresented: $isPresentedSettingSheet) {
            SettingView(
                sourceDevices: $enableDevices,
                sourceLocales: $enableLocales,
                sourceCalendars: $enableCalendars,
                sourceTimeZones: $enableTimeZones,
                defaultDevices: defaultDevices,
                defaultLocales: defaultLocales,
                defaultCalendars: defaultCalendars,
                defaultTimeZones: defaultTimeZones
            )
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
                if let device = device {
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
                            legibilityWeight: legibilityWeight,
                            colorScheme: isDark ? .dark : .light,
                            accentColor: isDark ? accentColorDark : accentColorLight,
                            calendar: calendar,
                            timeZone: timeZone,
                            dynamicTypeSize: dynamicTypeSize
                        )
                }

                //
                // Controls
                //
                Group {
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
                .accentColor(.blue)
            }
            .background(Color.simulatorBackground)
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
                    device = prev
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
                    device = next
                }
            } label: {
                Icon("chevron.down.square.fill")
            }
            .disabled(nextDevice() == nil)
        }
    }

    private func prevDevice() -> Device? {
        guard let device = device else { return nil }
        return enableDevices.sorted().prev(device)
    }

    private func nextDevice() -> Device? {
        guard let device = device else { return nil }
        return enableDevices.sorted().next(device)
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

                //
                // 􀏠 Dual mode
                //
                if horizontalSizeClass == .regular {
                    Button {
                        isDualMode.toggle()
                    } label: {
                        Icon(isDualMode ? "rectangle.portrait.on.rectangle.portrait.slash" : "rectangle.portrait.on.rectangle.portrait")
                    }
                    .disabled(device == nil)

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
                if isDynamicTypeSizesEnabled {
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
                //
                // 􀧞 Calendar / TimeZone
                //
                Menu {
                    //
                    // Calendar
                    //
                    Picker(selection: $calendar) {
                        ForEach(Array(enableCalendars.sorted().reversed())) { identifier in
                            Text(identifier.id).tag(identifier)
                        }
                    } label: {
                        EmptyView()
                    }

                    Divider() // ----

                    //
                    // TimeZone
                    //
                    // e.g.
                    // - America/New_York
                    // - Asia/Tokyo
                    // - Current
                    //
                    Picker(selection: $timeZone) {
                        Label("Default", systemImage: "iphone").tag(TimeZones.current)
                        ForEach(Array(enableTimeZones.sorted().reversed())) { timeZone in
                            Text(timeZone.label).tag(timeZone)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("calendar.badge.clock")
                }

                //
                // 􀀄 Locale
                //
                Menu {
                    Picker(selection: $locale) {
                        ForEach(Array(enableLocales.sorted().reversed()), id: \.self) { identifier in
                            Text(identifier).tag(identifier)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    Icon("a.circle")
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
                // 􀎮 / 􀎰 Rotate
                //
                if horizontalSizeClass == .regular {
                    Button {
                        isPortrait.toggle()
                    } label: {
                        Icon(isPortrait ? "rotate.left" : "rotate.right")
                    }
                    .disabled(device == nil)
                }

                //
                // 􀟝 Device
                //
                Menu {
                    Picker(selection: $device) {
                        let devices = enableDevices.sorted().reversed()
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
            // Footer: e.g. "xSmall" and "ja_JP / iso8601 / Asia/Tokyo"
            //
            if isDisplayInformation {
                HStack {
                    if isDynamicTypeSizesEnabled {
                        Text(dynamicTypeSize.label)
                    }
                    Spacer()
                    Text("\(locale) / \(calendar.rawValue) / \(timeZone.rawValue)")
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
            legibilityWeight: legibilityWeight,
            colorScheme: colorScheme,
            accentColor: colorScheme == .dark ? accentColorDark : accentColorLight,
            calendar: calendar,
            timeZone: timeZone,
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
        legibilityWeight: LegibilityWeight,
        colorScheme: ColorScheme,
        accentColor: Color?,
        calendar: Calendar.Identifier,
        timeZone: TimeZones,
        dynamicTypeSize: DynamicTypeSizeWrapper?
    ) -> some View {
        environment(\.locale, .init(identifier: locale))
            .environment(\.legibilityWeight, legibilityWeight) // 🚫 `legibilityWeight` is not working currently. (Same for Xcode preview)
            .environment(\.colorScheme, colorScheme)
            .environment(\.calendar, Calendar(identifier: calendar))
            .environment(\.timeZone, timeZone.toTimeZone())
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
            .whenLet(accentColor) { content, color in
                content.accentColor(color)
            }
    }
}
