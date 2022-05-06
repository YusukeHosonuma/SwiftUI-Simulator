//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/05.
//

import Foundation

extension UUID {
    mutating func refresh() {
        self = UUID()
    }
}
