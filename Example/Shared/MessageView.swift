//
//  MessageView.swift
//  Example
//
//  Created by Yusuke Hosonuma on 2022/04/27.
//

import SwiftUI

struct MessageView: View {
    init() {
        print()
    }

    var body: some View {
        Text(LocalizedStringKey("message"))
            .font(.title3)
            .bold()
            .padding(.bottom, 64)
            .debugFilename()
    }
}
