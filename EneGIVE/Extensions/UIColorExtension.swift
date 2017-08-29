//
//  EneGIVE - UIColorExtension.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int32) {
        let red: CGFloat   = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue: CGFloat  = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
