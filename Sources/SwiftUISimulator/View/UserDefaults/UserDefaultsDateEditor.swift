//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/05.
//

import SwiftUI

struct UserDefaultsDateEditor: View {
    @Binding var date: Date
    @Binding var isValid: Bool
    
    //
    // 💡 Note:
    // Just updating via binding is not enough to update text value. (why?)
    // Therefore update via `id`.
    //
    @State private var dateEditorID = UUID()

    var body: some View {
        //
        // ⚠️ FIXME: The display is corrupted when the keyboard is shown.
        //
        VStack {
            UserDefaultsStringEditor($date, isValid: $isValid)
                .id(dateEditorID)

            DatePicker(selection: .init(
                get: { date },
                set: {
                    date = $0
                    dateEditorID.refresh()
                }
            )) {
                EmptyView()
            }
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}
