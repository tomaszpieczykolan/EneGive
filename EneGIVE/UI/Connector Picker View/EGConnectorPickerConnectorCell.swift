//
//  EneGIVE - EGConnectorPickerConnectorCell.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class EGConnectorPickerConnectorCell: UITableViewCell {
    
    @IBOutlet weak var connectorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var voltageLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = Config.Color.primary
            } else {
                self.backgroundColor = Config.Color.background
            }
        }
    }
}
