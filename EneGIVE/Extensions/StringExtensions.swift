//
//  EneGIVE - StringExtensions.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
