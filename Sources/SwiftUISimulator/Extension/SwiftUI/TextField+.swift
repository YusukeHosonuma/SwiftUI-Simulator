//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/04.
//

import SwiftUI

extension TextField {
    enum Style {
        case valueEditor
    }

    @ViewBuilder
    func style(_ style: Style) -> some View {
        switch style {
        case .valueEditor:
            padding()
                .border(.gray.opacity(0.5))
                .font(.valueEditor)
        }
    }
}
