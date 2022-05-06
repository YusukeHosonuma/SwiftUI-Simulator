//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

//
// Stored as JSON string.
//
// e.g.
// `{"rawValue":{"red":0,"alpha":1,"blue":0,"green":0}}`)
//
struct JSONString {
    let dictionary: [String: Any]
}
