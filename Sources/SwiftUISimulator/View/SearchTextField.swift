//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct SearchTextField: View {
    @Binding private var text: String
    @State private var showCancelButton = false

    private let title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField(title, text: $text, onEditingChanged: { _ in
                self.showCancelButton = true
            })
            .autocapitalization(.none)
            .disableAutocorrection(true)

            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .opacity(text == "" ? 0 : 1)
            }
        }
        .padding(8)
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}
