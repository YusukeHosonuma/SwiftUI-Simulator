//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/19.
//

import SwiftUI

@available(iOS, obsoleted: 15.0)
extension Section where Parent == Text, Content: View, Footer == EmptyView {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(content: content) {
            Text(titleKey)
        }
    }

    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.init(content: content) {
            Text(title)
        }
    }
}
