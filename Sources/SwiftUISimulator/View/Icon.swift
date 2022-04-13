//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

//
// Icon("a.circle")
//
struct Icon: View {
    private let systemName: String

    init(_ systemName: String) {
        self.systemName = systemName
    }

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 20))
            .frame(width: 48, height: 48)
            .contentShape(Rectangle())
    }
}
