//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/14.
//

import Foundation

extension Array where Element: Equatable {
    func prev(_ element: Element) -> Element? {
        if let index = firstIndex(of: element), indices.contains(index - 1) {
            return self[index - 1]
        } else {
            return nil
        }
    }

    func next(_ element: Element) -> Element? {
        if let index = firstIndex(of: element), indices.contains(index + 1) {
            return self[index + 1]
        } else {
            return nil
        }
    }
}
