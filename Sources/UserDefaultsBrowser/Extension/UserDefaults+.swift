//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

extension UserDefaults {
    static let keyRepository = "YusukeHosonuma/UserDefaultsBrowser"
    static let keyVersion = "1.0.0" // 💡 Please update version number when data incompatibility occur.
    
    static let keyPrefix: String = "\(keyRepository)/\(keyVersion)/"

    func lookup(forKey key: String) -> Any? {
        if let _ = value(forKey: key) as? Data, let url = url(forKey: key) {
            return url
        }

        if let dict = dictionary(forKey: key) {
            return dict
        }

        if let data = data(forKey: key),
           let decoded = try? JSONSerialization.jsonObject(with: data),
           let dict = decoded as? [String: Any]
        {
            return JSONData(dictionary: dict)
        }

        if let string = string(forKey: key),
           string.hasPrefix("{"),
           string.hasSuffix("}"),
           let dict = string.jsonToDictionary()
        {
            return JSONString(dictionary: dict)
        }

        return value(forKey: key)
    }
}
