//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/12.
//

import SwiftUI

struct LocaleSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    private let selectedLocaleIdentifiers: Binding<Set<String>>

    init(selectedLocaleIdentifiers: Binding<Set<String>>) {
        self.selectedLocaleIdentifiers = selectedLocaleIdentifiers
    }

    private var localeIdentifiers: [String] {
        Locale.availableIdentifiers.filter { $0.contains("_") }.sorted()
    }

    var body: some View {
        NavigationView {
            List(selection: selectedLocaleIdentifiers) {
                Section {
                    ForEach(localeIdentifiers, id: \.self) { identifier in
                        Text(identifier).tag(identifier)
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedLocaleIdentifiers.wrappedValue.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        selectedLocaleIdentifiers.wrappedValue = []
                    }
                }
            }
        }
    }
}
