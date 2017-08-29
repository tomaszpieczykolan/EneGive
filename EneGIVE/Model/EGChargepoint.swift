//
//  EneGIVE - EGChargepoint.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

struct EGChargepoint {
    
    enum EGChargepointAvailabilityStatus: CustomStringConvertible {
        case active
        case inactive
        
        var description: String {
            switch self {
            case .active:
                return "Chargepoint is active"
            case .inactive:
                return "Chargepoint is inactive"
            }
        }
    }
    
    
    var id: String
    var name: String
    var availability: EGChargepointAvailabilityStatus
    var latitude: Double
    var longitude: Double
    
    
    init(_ dict: [AnyHashable: Any]) {
        let availabilityString = (dict["AvailabilityStatus"] as? String)
        
        id           = dict["Id"]   as? String ?? ""
        name         = dict["Name"] as? String ?? ""
        availability = availabilityString == "Active" ? EGChargepoint.EGChargepointAvailabilityStatus.active : EGChargepoint.EGChargepointAvailabilityStatus.inactive
        latitude     = dict["GeolocationLatitude"]  as? Double ?? 0.0
        longitude    = dict["GeolocationLongitude"] as? Double ?? 0.0
    }
}
