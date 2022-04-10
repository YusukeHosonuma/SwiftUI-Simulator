//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import Foundation

protocol SliderCompatible {
    static var sliderRange: ClosedRange<Double> { get }
    var sliderIndex: Int { get }
    init(fromSliderIndex: Int)
}
