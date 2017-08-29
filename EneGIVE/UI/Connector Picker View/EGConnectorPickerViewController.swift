//
//  EneGIVE - EGConnectorPickerViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class EGConnectorPickerViewController: UIViewController {
    
    
    enum ReuseIdentifiers {
        static let chargePointCell: String = "EneGive-ConnectorPickerView-ChargePointCell"
        static let connectorCell: String = "EneGive-ConnectorPickerView-ConnectorCell"
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var connectors: [EGConnector]? {
        set {
            guard let newVal = newValue else { return }
            var chargePointIDs: [String] = []
            for connector in newVal {
                if !chargePointIDs.contains(connector.chargePointID) {
                    chargePointIDs.append(connector.chargePointID)
                }
            }
            var grouped = [[EGConnector]]()
            for chargePointID in chargePointIDs {
                grouped.append(newVal.filter({ $0.chargePointID == chargePointID }))
            }
            connectorsByChargePoint = grouped
        }
        get {
            return connectorsByChargePoint?.flatMap { $0 }
        }
    }
    
    var connectorsByChargePoint: [[EGConnector]]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "EGConnectorPickerView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40.0
        tableView.contentInset = UIEdgeInsets(top: 32.0, left: 0.0, bottom: -1.0, right: 0.0)
        
        tableView.register(UINib(nibName: "EGConnectorPickerChargePointCell", bundle: nil), forCellReuseIdentifier: ReuseIdentifiers.chargePointCell)
        tableView.register(UINib(nibName: "EGConnectorPickerConnectorCell",   bundle: nil), forCellReuseIdentifier: ReuseIdentifiers.connectorCell)
    }
    
    
    
    // MARK: -
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension EGConnectorPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        AccountManager.shared.selectedConnector = connectorsByChargePoint?[safe: indexPath.section]?[safe: indexPath.row - 1]
        EGRootViewController.main?.presentChargeVC()
        self.dismiss(animated: false, completion: nil)
    }
}

extension EGConnectorPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return connectorsByChargePoint?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (connectorsByChargePoint?[section].count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.chargePointCell, for: indexPath) as! EGConnectorPickerChargePointCell
            cell.titleLabel.text = connectorsByChargePoint?[indexPath.section].first?.chargePointID
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.connectorCell, for: indexPath) as! EGConnectorPickerConnectorCell
            if let connector = connectorsByChargePoint?[indexPath.section][indexPath.item - 1] {
                cell.connectorImageView.image = #imageLiteral(resourceName: "Type_2_mennekes")
                cell.nameLabel.text = connector.name
                cell.priceLabel.text = "Price: \(connector.price.priceFormatted)"
                cell.voltageLabel.text = "\(connector.voltage) V"
                cell.currentLabel.text = "\(connector.current) A"
            }
            return cell
        }
    }
}
