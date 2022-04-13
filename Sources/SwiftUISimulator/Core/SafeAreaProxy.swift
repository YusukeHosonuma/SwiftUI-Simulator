//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/12.
//

import SwiftUI

struct SafeAreaProxy {
    private let screenSize: CGSize
    private let safeArea: SafeArea
    private let orientation: DeviceOrientation

    init(screenSize: CGSize, safeArea: SafeArea, orientation: DeviceOrientation) {
        self.screenSize = screenSize
        self.safeArea = safeArea
        self.orientation = orientation
    }

    var top: CGFloat {
        orientation == .portrait
            ? safeArea.portrait.top
            : safeArea.landscape.top
    }

    var bottom: CGFloat {
        orientation == .portrait
            ? safeArea.portrait.bottom
            : safeArea.landscape.bottom
    }

    var left: CGFloat {
        orientation == .landscape ? safeArea.landscape.left : 0
    }

    var right: CGFloat {
        orientation == .landscape ? safeArea.landscape.right : 0
    }

    var width: CGFloat {
        left + right
    }

    var height: CGFloat {
        top + bottom
    }

    var contentSize: CGSize {
        switch orientation {
        case .portrait:
            return CGSize(width: screenSize.width - width, height: screenSize.height - height)
        case .landscape:
            return CGSize(width: screenSize.height - width, height: screenSize.width - height)
        }
    }
}
