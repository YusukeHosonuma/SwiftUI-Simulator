//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

extension Binding {
    //
    // `Binding<T?>` -> `Binding<T>?`
    //
    func wrappedBinding<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        if let value = wrappedValue {
            return .init(
                get: { value },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }
}
