//
//  EneGIVE - JSONUtility.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

enum JSONUtility {
    static func serialize(_ data: Data?) -> Any? {
        guard let rawData = data else { return nil }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: rawData, options: JSONSerialization.ReadingOptions(rawValue: 0))
            return jsonResult
        } catch {
            print("Catched error == \(error.localizedDescription)")
            
            return nil
        }
    }
}
