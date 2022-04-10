//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

enum DeviceOrientation {
    case portrait
    case landscape

    init(deviceSize: CGSize) {
        self = deviceSize.height > deviceSize.width ? .portrait : .landscape
    }
}
