//
//  EneGIVE - MapViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [EGLocation]? {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            guard let newLocations = locations else { return }
            for location in newLocations {
                let annotation = EGMapAnnotationLocation(model: location, lat: location.latitude, lon: location.longitude, title: location.name, subtitle: "\(location.street), \(location.city), \(location.country) (\(location.attractiveness))")
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "MapView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.location { [weak self] (locations, error) in
            guard error == nil else { return }
            self?.locations = locations
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func locateButtonPressed() {
        
        guard let location = locations?.first else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span   = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? EGMapAnnotationLocation else { return }
        guard let location = annotation.model else { return }
        if let connectorPickerView = view.detailCalloutAccessoryView as? EGMapLocationView {
            guard connectorPickerView.connectors == nil else { return }
            API.connector(locationID: location.id) { (connectors, error) in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    connectorPickerView.connectors = connectors
                }
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tap!")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view: MKAnnotationView = {
            let reuseIdentifier = "EneGive-MapView-ReusableAnnotationView"
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
                return view
            }
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view.pinTintColor = Config.Color.primary
            view.canShowCallout = true
            
            let connectorPicker = Bundle.main.loadNibNamed("EGMapLocationView", owner: nil, options: nil)!.first as! EGMapLocationView
            connectorPicker.mapViewController = self
            connectorPicker.location = (annotation as? EGMapAnnotationLocation)?.model
            
            view.detailCalloutAccessoryView = connectorPicker
            
            return view
        }()
        
        return view
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
