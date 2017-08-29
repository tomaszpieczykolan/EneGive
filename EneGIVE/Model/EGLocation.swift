//
//  EneGIVE - EGLocation.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

struct EGLocation {
    
    var id: String
    var name: String
    var attractiveness: Int
    var latitude: Double
    var longitude: Double
    var street: String
    var city: String
    var country: String
    
    
    init(_ dict: [AnyHashable: Any]) {
        id             = dict["Id"]                   as? String ?? ""
        name           = dict["Name"]                 as? String ?? ""
        attractiveness = dict["Attractiveness"]       as? Int    ?? -1
        latitude       = dict["GeolocationLatitude"]  as? Double ?? 0.0
        longitude      = dict["GeolocationLongitude"] as? Double ?? 0.0
        street         = dict["Street"]               as? String ?? ""
        city           = dict["City"]                 as? String ?? ""
        country        = dict["Country"]              as? String ?? ""
    }
}
