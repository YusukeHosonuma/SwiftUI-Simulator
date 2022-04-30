//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct DynamicTypeSizeSlider: View {
    @Binding var dynamicTypeSize: DynamicTypeSizeWrapper

    var body: some View {
        Slider(
            value: $dynamicTypeSize.sliderBinding(),
            in: DynamicTypeSizeWrapper.sliderRange,
            step: 1
        )
    }
}
