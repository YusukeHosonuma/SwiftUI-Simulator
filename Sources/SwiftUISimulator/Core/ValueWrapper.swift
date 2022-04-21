//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/04/21.
//

import Foundation

protocol ValueWrapper {
    associatedtype RawValue
    var rawValue: RawValue { get }
    init(_: RawValue)
}
