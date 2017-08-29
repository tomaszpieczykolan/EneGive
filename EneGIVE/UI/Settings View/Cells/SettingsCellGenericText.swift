//
//  EneGIVE - SettingsCellGenericText.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class SettingsCellGenericText: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    var title: String {
        get {
            return label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
}
