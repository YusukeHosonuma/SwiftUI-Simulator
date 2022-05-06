//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

extension Array where Element == Any {
    static func from(jsonString: String) -> [Any]? {
        guard
            let data = jsonString.data(using: .utf8),
            let decoded = try? JSONSerialization.jsonObject(with: data),
            let array = decoded as? [Any] else { return nil }

        return array
    }

    var prettyJSON: String {
        let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        )
        return String(data: jsonData!, encoding: .utf8)!
    }
}
