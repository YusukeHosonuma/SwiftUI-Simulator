//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import Foundation

extension Sequence {
    func matchAny(_ matcher: (Element) -> Bool) -> Bool {
        reduce(false) { $0 || matcher($1) }
    }
}
