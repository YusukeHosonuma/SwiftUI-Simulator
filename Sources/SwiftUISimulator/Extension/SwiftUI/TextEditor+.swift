//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/04.
//

import SwiftUI

extension TextEditor {
    enum Style {
        case valueEditor
    }

    @ViewBuilder
    func style(_ style: Style) -> some View {
        switch style {
        case .valueEditor:
            border(.gray.opacity(0.5))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.codeStyle)
        }
    }
}
