//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/04.
//

import SwiftUI

struct UserDefaultsBoolEditor: View {
    @Binding var value: Bool

    var body: some View {
        Picker(selection: $value) {
            Text("true").tag(true)
            Text("false").tag(false)
        } label: {
            EmptyView()
        }
        .pickerStyle(.segmented)
    }
}
