//
//  EneGIVE - EGMapAnnotationLocation.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import MapKit

class EGMapAnnotationLocation: NSObject, MKAnnotation {
    
    // Center latitude and longitude of the annotation view.
    // The implementation of this property must be KVO compliant.
    var coordinate: CLLocationCoordinate2D
    
    // Title and subtitle for use by selection UI.
    var title: String?
    var subtitle: String?
    
    var model: EGLocation?
    
    init(model: EGLocation?, lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees, title: String = "Chargepoint", subtitle: String? = nil) {
        self.model = model
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = subtitle
    }
}
