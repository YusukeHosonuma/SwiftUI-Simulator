//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

extension Binding where Value: SliderValue {
    func sliderBinding() -> Binding<Double> {
        .init(
            get: {
                Double(self.wrappedValue.sliderIndex)
            },
            set: {
                self.wrappedValue = Value(fromSliderIndex: Int($0))
            }
        )
    }
}

extension Binding where Value: ValueWrapper {
    var rawValue: Binding<Value.RawValue> {
        .init(
            get: { self.wrappedValue.rawValue },
            set: { self.wrappedValue = .init($0) }
        )
    }
}
