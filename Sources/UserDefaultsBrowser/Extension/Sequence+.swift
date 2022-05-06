//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

extension Sequence {
    func exclude(_ isExcluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try isExcluded($0) == false }
    }
}
