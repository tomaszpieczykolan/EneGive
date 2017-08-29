//
//  EneGIVE - DTButton.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class DTButton: UIButton {
    
    let textStyle: UIFontTextStyle = .title3
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(DTButton.preferredContentSizeChanged(_:)), name: .UIContentSizeCategoryDidChange, object: nil)
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    func preferredContentSizeChanged(_ notification: NSNotification) {
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
