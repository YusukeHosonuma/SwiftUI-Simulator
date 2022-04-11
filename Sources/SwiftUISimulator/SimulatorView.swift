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
    private var locale: LocaleType = .jaJP

    @available(iOS 15, *)
    @AppStorage("SwiftUI-Simulator.dynamicTypeSize")
    private var dynamicTypeSize: DynamicTypeSize = .medium

    @AppStorage("SwiftUI-Simulator.isDynamicTypeSizesEnabled")
    private var isDynamicTypeSizesEnabled = false

    @AppStorage("SwiftUI-Simulator.isDark")
    private var isDark = false

    @AppStorage("SwiftUI-Simulator.isDisplaySafeArea")
    private var isDisplaySafeArea = true

    @AppStorage("SwiftUI-Simulator.isSimulatorEnabled")
    private var isSimulatorEnabled = true

    @AppStorage("SwiftUI-Simulator.calendarIdentifier")
    private var calendarIdentifier: Calendar.Identifier = .iso8601

    // 💡 Note: save and restore by code.
    @State private var enableDevices: Set<Device>

    @State private var isPresentedDeviceSelectSheet = false

    private let content: () -> Content
    
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

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        enableDevices = Self.loadEnableDevices()
    }

    public var body: some View {
        GeometryReader { reader in
            VStack {
                Group {
                    if isSimulatorEnabled {
                        simulatorContainer(deviceSize: reader.size, orientation: .init(deviceSize: reader.size))
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

    @ViewBuilder
    private func simulatorContainer(deviceSize: CGSize, orientation: DeviceOrientation) -> some View {
        ZStack(alignment: .bottomLeading) {
            simulatedContent(orientation: orientation)
                .offset(y: -32)
                .animation(.default, value: device)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                //
                // 􀣌 Setting menu
                //
                Menu {
                    Button {
                        isSimulatorEnabled.toggle()
                    } label: {
                        Label("Disable simulator", systemImage: "power")
                    }

                    Divider()

                    Button {
                        isPresentedDeviceSelectSheet.toggle()
                    } label: {
                        Label("Select devices", systemImage: "iphone")
                    }

                    Divider()

                    Toggle(isOn: $isDynamicTypeSizesEnabled) {
                        Label("Dynamic Type Sizes", systemImage: "a.square")
                    }
                    Toggle(isOn: $isDisplaySafeArea) {
                        Label("Safe Area", systemImage: "square.tophalf.filled")
                    }
                } label: {
                    Icon("gearshape.fill")
                }
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
                // 􀟝 Device
                //
                Menu {
                    Picker(selection: $device) {
                        let devices = orientation == .portrait
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

                //
                // 􀫖 Locale
                //
                Menu {
                    Picker(selection: $locale) {
                        ForEach(LocaleType.allCases, id: \.rawValue) { locale in
                            Text(locale.rawValue).tag(locale)
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
                    Picker(selection: $calendarIdentifier) {
                        ForEach(Calendar.Identifier.allCases) { identifier in
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
            .frame(height: 64)
            .background(Color.gray.opacity(0.05))
        }
    }

    @ViewBuilder
    private func simulatedContent(orientation: DeviceOrientation) -> some View {
        let safeAreaHeight = device.safeAreaTop + device.safeAreaBottom
        let fw = device.size.width
        let fh = device.size.height - (isDisplaySafeArea ? 0 : safeAreaHeight)
        let (frameWidth, _) = orientation == .portrait ? (fw, fh) : (fh, fw)

        let w = device.size.width
        let h = device.size.height - safeAreaHeight
        let (width, height) = orientation == .portrait ? (w, h) : (h, w)

        ZStack(alignment: .topLeading) {
            ZStack(alignment: .bottomLeading) {
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
                .environment(\.locale, .init(identifier: locale.rawValue))
                .environment(\.colorScheme, isDark ? .dark : .light)
                .environment(\.calendar, Calendar(identifier: calendarIdentifier))
                .when(isDynamicTypeSizesEnabled) {
                    if #available(iOS 15, *) {
                        $0.environment(\.dynamicTypeSize, dynamicTypeSize)
                    } else {
                        $0
                    }
                }

                footer()
                    .offset(y: 24)
                    .frame(width: frameWidth)
            }

            header()
                .offset(y: -24)
                .frame(width: frameWidth)
        }
        .sheet(isPresented: $isPresentedDeviceSelectSheet, onDismiss: {
            saveEnableDevices()
        }, content: {
            DeviceSelectView(selectedDevices: $enableDevices)
        })
    }

    @ViewBuilder
    private func header() -> some View {
        let w = Int(device.size.width)
        let h = Int(device.size.height)
        HStack {
            Text("\(device.name) - \(device.inch) (\(w) x \(h))")
            Spacer()
            Text("\(locale.rawValue)")
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
        }
        .foregroundColor(.gray)
    }
}
