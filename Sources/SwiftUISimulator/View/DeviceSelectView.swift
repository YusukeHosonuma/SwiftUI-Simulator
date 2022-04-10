//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

struct DeviceSelectView: View {
    @Environment(\.dismiss) private var dismiss

    private let selectedDevices: Binding<Set<Device>>

    init(selectedDevices: Binding<Set<Device>>) {
        self.selectedDevices = selectedDevices
    }

    var body: some View {
        NavigationView {
            List(selection: selectedDevices) {
                Section("iPhone") {
                    ForEach(Device.allCases.filter { $0.isIpad == false }, id: \.name) { device in
                        Text(device.name)
                            .tag(device)
                    }
                }
                Section("iPad") {
                    ForEach(Device.allCases.filter(\.isIpad), id: \.name) { device in
                        Text(device.name)
                            .tag(device)
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        dismiss()
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
