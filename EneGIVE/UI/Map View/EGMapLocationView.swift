//
//  EneGIVE - EGMapLocationView.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit
import MapKit

class EGMapLocationView: UIView {
    
    
    enum ReuseIdentifiers {
        static let connectorCell: String = "EneGive-MapLocationView-ConnectorCell"
    }
    
    
    
    weak var mapViewController: MapViewController?
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var location: EGLocation? {
        didSet {
            if let loc = location {
                addressLabel?.text = "\(loc.street)\n\(loc.city), \(loc.country)\nAttractiveness: \(loc.attractiveness)"
            }
        }
    }
    
    var connectors: [EGConnector]? {
        set {
            guard let newVal = newValue else { return }
            var types: [EGConnector.EGConnectorType] = []
            for connector in newVal {
                if !types.contains(connector.type) {
                    types.append(connector.type)
                }
            }
            var grouped = [[EGConnector]]()
            for type in types {
                grouped.append(newVal.filter({ $0.type == type }))
            }
            groupedConnectors = grouped
        }
        get {
            return groupedConnectors?.flatMap { $0 }
        }
    }
    
    var groupedConnectors: [[EGConnector]]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "EGConnectorCell", bundle: nil), forCellWithReuseIdentifier: ReuseIdentifiers.connectorCell)
        setupConstraints()
        
        if let loc = location {
            addressLabel?.text = "\(loc.street)\n\(loc.city), \(loc.country)\nAttractiveness: \(loc.attractiveness)"
        }
    }
    
    
    
    // MARK: - Layout
    
    func setupConstraints() {
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 170.0),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0)
        ])
    }
    
    
    
    // MARK: -
    @IBAction func getDirectionsButtonPressed() {
        guard let loc = self.location else { return }
        guard let googleMapsBaseURL = URL(string: "comgooglemaps://") else { return }
        guard let googleMapsURL = URL(string: "comgooglemaps://?saddr=&daddr=\(loc.latitude),\(loc.longitude)&directionsmode=driving") else { return }
        
        if UIApplication.shared.canOpenURL(googleMapsBaseURL) {
            UIApplication.shared.openURL(googleMapsURL)
        } else {
            let coordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = loc.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @IBAction func chargeHereButtonPressed() {
        AccountManager.shared.selectedLocation = location
        
        let connectorPickerVC = EGConnectorPickerViewController()
        
        connectorPickerVC.connectors = self.connectors
        
        connectorPickerVC.modalPresentationStyle = .overCurrentContext
        
        mapViewController?.present(connectorPickerVC, animated: true, completion: nil)
    }
    
}

extension EGMapLocationView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //AccountManager.shared.selectedLocationConnectors = connectors
        //AccountManager.shared.selectedConnector = indexPath.item
    }
}

extension EGMapLocationView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return groupedConnectors?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.connectorCell, for: indexPath) as! EGConnectorCell
            if let connectorGroup = groupedConnectors?[indexPath.item], let first = connectorGroup.first {
                cell.countLabel.text = "\(connectorGroup.count)"
                cell.nameLabel.text = first.name
                switch first.status {
                case .active:
                    cell.availabilityImageView.image = #imageLiteral(resourceName: "Available")
                case .inactive:
                    cell.availabilityImageView.image = #imageLiteral(resourceName: "Unavailable")
                }
                cell.connectorImageView.image = #imageLiteral(resourceName: "Chademo_type4")
                //cell.statusLabel.text = "\(connector.status)"
            }
            return cell
        default:
            fatalError()
        }
    }
}
