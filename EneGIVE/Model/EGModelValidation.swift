//
//  EneGIVE - EGModelValidation.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

enum EGModelValidation {
    
    @discardableResult
    static func validateGuard(_ modelName: String, _ dict: [AnyHashable: Any], _ assertions: Bool...) -> Bool {
        let isValid = !assertions.contains(false)
        guard !isValid else { return isValid }
        
        print()
        print("**********  Received unexpected data from backend.  **********")
        print("Model: \(modelName)")
        let width = (dict.max { ($0.0.key as? String ?? "").characters.count < ($0.1.key as? String ?? "").characters.count }?.key as? String)?.characters.count ?? 0
        for item in dict {
            let k: String = (item.key as? String) ?? "\(item.key)"
            let widthToAdd = max(0, width - k.characters.count)
            let space = String(repeating: " ", count: widthToAdd)
            var v: String
            if let s = item.value as? String {
                v = "\"\(s)\""
            } else {
                v = "\(item.value)"
            }
            print("    \(k):\(space) \(v)")
        }
        print("**************************************************************")
        print()
        
        return isValid
    }
    
}
