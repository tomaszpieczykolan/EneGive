//
//  EneGIVE - EGConnector.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation
import UIKit

struct EGConnector {
    
    enum EGConnectorAvailabilityStatus {
        case active
        case inactive
    }
    
    enum EGConnectorType {
        case fast
        case unknown
    }
    
    
    var id: String
    var chargePointID: String
    var name: String
    var type: EGConnectorType
    var status: EGConnectorAvailabilityStatus
    var price: Decimal
    var voltage: CGFloat
    var current: CGFloat
    
    
    init(_ dict: [AnyHashable: Any]) {
        id            = dict["Id"]                        as? String ?? "nil"
        chargePointID = dict["ChargePointId"]             as? String ?? "nil"
        name          = dict["Name"]                      as? String ?? ""
        voltage       = CGFloat(dict["ElectricPotential"] as? Int    ?? -1)
        current       = CGFloat(dict["ElectricCurrent"]   as? Int    ?? -1)
        
        let typeString   = dict["ConnType"] as? String ?? ""
        let statusString = dict["Status"]   as? String ?? ""
        let priceString  = dict["Price"]    as? String ?? ""
        
        type   = typeString   == "FAST"      ? EGConnector.EGConnectorType.fast : EGConnector.EGConnectorType.unknown
        status = statusString == "Available" ? EGConnector.EGConnectorAvailabilityStatus.active : EGConnector.EGConnectorAvailabilityStatus.inactive
        price  = Decimal(string: priceString) ?? 0.0
        
        EGModelValidation.validateGuard(#file, dict, id != "nil", chargePointID != "nil", name != "", voltage != -1, current != -1)
    }
}
