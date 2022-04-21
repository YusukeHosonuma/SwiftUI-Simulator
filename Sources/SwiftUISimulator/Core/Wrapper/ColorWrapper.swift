//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/04/21.
//

import SwiftUI

struct ColorWrapper: ValueWrapper, Codable {
    let rawValue: Color
    
    init(_ rawValue: Color) {
        self.rawValue = rawValue
    }
}
