//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

struct DeviceSelectView: View {

    // 💡 iOS 15+
    @Environment(\.presentationMode) var presentationMode
    
    private let selectedDevices: Binding<Set<Device>>

    init(selectedDevices: Binding<Set<Device>>) {
        self.selectedDevices = selectedDevices
    }

    var body: some View {
        NavigationView {
            List(selection: selectedDevices) {
                //
                // 💡 iOS 15+
                //
                // `Section("xxx") { ... }`
                // https://developer.apple.com/documentation/swiftui/section/init(_:content:)-90be4
                //
                Section {
                    ForEach(Device.allCases.filter { $0.isIpad == false }, id: \.name) { device in
                        Text(device.name)
                            .tag(device)
                    }
                } header: {
                    Text("iPhone")
                }
                
                Section {
                    ForEach(Device.allCases.filter(\.isIpad), id: \.name) { device in
                        Text(device.name)
                            .tag(device)
                    }
                } header: {
                    Text("iPad")
                }
            }
            .environment(\.editMode, .constant(.active))
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedDevices.wrappedValue.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        selectedDevices.wrappedValue = []
                    }
                }
            }
        }
    }
}
