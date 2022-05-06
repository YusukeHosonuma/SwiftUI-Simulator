//
//  View+.swift
//  Example (iOS)
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI
import SwiftUISimulator

extension View {
    func simulatableSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        #if DEBUG
        simulatedSheet(isPresented: isPresented, content: content)
        #else
        sheet(isPresented: isPresented, content: content)
        #endif
    }
}
