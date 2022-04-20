//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/19.
//

import SwiftUI

struct SettingView: View {
    let sourceDevices: Binding<Set<Device>>
    let sourceLocales: Binding<Set<String>>
    let sourceCalendars: Binding<Set<Calendar.Identifier>>
    let sourceTimeZones: Binding<Set<TimeZones>>
    let defaultDevices: Set<Device>
    let defaultLocales: Set<String>
    let defaultCalendars: Set<Calendar.Identifier>
    let defaultTimeZones: Set<TimeZones>

    @AppStorage("\(storageKeyPrefix).SettingView.isExpandedDevice")
    private var isExpandedDevice = true

    @AppStorage("\(storageKeyPrefix).SettingView.isExpandedLocale")
    private var isExpandedLocale = true

    @AppStorage("\(storageKeyPrefix).SettingView.isExpandedCalendar")
    private var isExpandedCalendar = true

    @AppStorage("\(storageKeyPrefix).SettingView.isExpandedTimeZone")
    private var isExpandedTimeZone = true

    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private var devices: [Device] {
        sourceDevices.wrappedValue.sorted()
    }

    private var locales: [String] {
        sourceLocales.wrappedValue.sorted()
    }

    private var calendars: [Calendar.Identifier] {
        sourceCalendars.wrappedValue.sorted()
    }

    private var timeZones: [TimeZones] {
        sourceTimeZones.wrappedValue.sorted()
    }

    var body: some View {
        NavigationView {
            Form {
                //
                // 􀟜 Device
                //
                Section {
                    DisclosureGroup(isExpanded: $isExpandedDevice) {
                        ForEach(devices) { device in
                            Text(device.name)
                        }
                        editLink {
                            DeviceSelectView(selectedDevices: sourceDevices)
                                .navigationTitle("Select Devices")
                        }
                    } label: {
                        Label("Device", systemImage: "iphone")
                    }
                }
                //
                // 􀀄 Locale
                //
                Section {
                    DisclosureGroup(isExpanded: $isExpandedLocale) {
                        ForEach(locales, id: \.self) { locale in
                            Text(locale)
                        }
                        editLink {
                            MultiItemSelectView(
                                selectedItems: sourceLocales,
                                allItems: Locale.availableIdentifiers.filter { $0.contains("_") }.sorted(),
                                searchableText: { $0 }
                            ) {
                                Text($0)
                            }
                            .navigationTitle("Select Locales")
                        }
                    } label: {
                        Label("Locale", systemImage: "a.circle")
                    }
                }
                //
                // 􀉉 Calendar
                //
                Section {
                    DisclosureGroup(isExpanded: $isExpandedCalendar) {
                        ForEach(calendars) { calendar in
                            Text(calendar.rawValue)
                        }
                        editLink {
                            MultiItemSelectView(
                                selectedItems: sourceCalendars,
                                allItems: Calendar.Identifier.allCases,
                                searchableText: { $0.rawValue }
                            ) {
                                Text($0.rawValue)
                            }
                            .navigationTitle("Select Calendars")
                        }
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                    }
                }
                //
                // 􀐫 TimeZone
                //
                Section {
                    DisclosureGroup(isExpanded: $isExpandedTimeZone) {
                        ForEach(timeZones) { timeZones in
                            Text(timeZones.label)
                        }
                        editLink {
                            MultiItemSelectView(
                                selectedItems: sourceTimeZones,
                                allItems: TimeZones.allCases.filter { $0 != .current }, // ☑️ Remove `current` from select.
                                searchableText: { $0.rawValue }
                            ) {
                                Text($0.label)
                            }
                            .navigationTitle("Select TimeZones")
                        }
                    } label: {
                        Label("TimeZone", systemImage: "clock")
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Reset to default") {
                            isPresentedResetAlert.toggle()
                        }
                        .foregroundColor(.red) // Destructive color
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $isPresentedResetAlert) {
                Alert(
                    title: Text("Reset to default values?"),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .destructive(
                        Text("Reset"),
                        action: {
                            resetToDefaults()
                        }
                    )
                )
            }
        }
    }

    @State private var isPresentedResetAlert = false

    func editLink<V: View>(_ destination: () -> V) -> some View {
        //
        // Edit
        //
        NavigationLink(destination: destination) {
            Text("Edit")
                .foregroundColor(.accentColor)
        }
    }

    // MARK: Action

    func resetToDefaults() {
        sourceDevices.wrappedValue = defaultDevices
        sourceLocales.wrappedValue = defaultLocales
        sourceCalendars.wrappedValue = defaultCalendars
        sourceTimeZones.wrappedValue = defaultTimeZones
    }
}
