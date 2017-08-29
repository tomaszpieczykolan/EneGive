//
//  EneGIVE - DecimalExtensions.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

extension Decimal {
    var priceFormatted: String {
        guard self != 0.0 else {
            return "Free".localized
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? "NaN"
    }
    
    var balanceFormatted: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? "NaN"
    }
}
