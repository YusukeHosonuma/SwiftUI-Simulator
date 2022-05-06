//
//  DismissSheet.swift
//  Example (iOS)
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI
import SwiftUISimulator

//
// Wrapper of `@Environment(\.presentationMode)`.
//
@propertyWrapper
struct DismissSheet: DynamicProperty {
    #if DEBUG
    @Environment(\.simulatedSheetDismiss) private var simulatedSheetDismiss
    #endif

    @Environment(\.presentationMode) private var presentationMode

    struct DismissAction {
        private var action: () -> Void

        init(_ action: @escaping () -> Void) {
            self.action = action
        }

        func callAsFunction() {
            action()
        }
    }

    var wrappedValue: DismissAction {
        #if DEBUG
        if let dismiss = simulatedSheetDismiss {
            return DismissAction(dismiss)
        } else {
            return DismissAction { presentationMode.wrappedValue.dismiss() }
        }
        #else
        DismissAction { presentationMode.wrappedValue.dismiss() }
        #endif
    }
}
