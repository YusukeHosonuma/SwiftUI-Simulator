//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

extension String {
    // 🌱 Special Thanks.
    // https://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    func jsonToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}
