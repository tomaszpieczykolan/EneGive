//
//  EneGIVE - ChargeViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class ChargeViewController: UIViewController {
    
    var isCharging: Bool = false
    @IBOutlet weak var chargingStatusLabel: UILabel!
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "ChargeView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let connector = AccountManager.shared.selectedConnector {
            chargingStatusLabel.text = connector.name
        }
        
        EGRootViewController.main?.chargingStatusViewIsActive = isCharging
    }
    
    
    
    // MARK: -
    
    @IBAction func closeButtonPressed() {
        EGRootViewController.main?.presentTabBarVC()
        EGRootViewController.main?.chargingStatusViewIsActive = isCharging
    }
    
    
    
    // MARK: - Charge limit
    
    var chargeLimit: Double = 20.0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            if let newLimitString = formatter.string(from: chargeLimit as NSNumber) {
                //chargeLimitLabel.text = "\(newLimitString) kW/h"
            }
        }
    }
    
    @IBAction func chargeLimitPan(_ gesture: UIPanGestureRecognizer) {
        let change = Double(gesture.translation(in: gesture.view).x / 10.0)
        
        guard gesture.state == .ended || gesture.state == .cancelled else {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            if let newLimitString = formatter.string(from: (chargeLimit + change) as NSNumber) {
                //chargeLimitLabel.text = "\(newLimitString) kW/h"
            }
            return
        }
        
        chargeLimit += Double(change)
    }
    
    @IBAction func chargeLimitDown() {
        chargeLimit = ceil(chargeLimit - 1.0)
    }
    
    @IBAction func chargeLimitUp() {
        chargeLimit = floor(chargeLimit + 1.0)
    }
    
    
    // MARK: - Charging
    
    @IBAction func startChargingButtonPressed(_ sender: UIButton) {
        guard let connector = AccountManager.shared.selectedConnector else { return }
        
        if isCharging {
            API.Charge.stop(chargePointID: connector.chargePointID, connectorID: connector.id) { [weak self] (status, error) in
                if let e = error {
                    print("Error: \(e)")
                    DispatchQueue.main.async {
                        self?.chargingStatusLabel.text = "Error: \(e)"
                    }
                    return
                }
                if status == "ACCEPTED" {
                    DispatchQueue.main.async {
                        self?.isCharging = false
                        sender.setTitle("Start charging", for: .normal)
                        if let connector = AccountManager.shared.selectedConnector {
                            self?.chargingStatusLabel.text = connector.name
                        } else {
                            self?.chargingStatusLabel.text = "Please select connector"
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.chargingStatusLabel.text = "Rejected"
                    }
                }
            }
        } else {
            API.Charge.start(chargePointID: connector.chargePointID, connectorID: connector.id) { [weak self] (status, error) in
                if let e = error {
                    print("Error: \(e)")
                    DispatchQueue.main.async {
                        self?.chargingStatusLabel.text = "Error: \(e)"
                    }
                    return
                }
                if status == "ACCEPTED" {
                    DispatchQueue.main.async {
                        self?.isCharging = true
                        sender.setTitle("Stop charging", for: .normal)
                        self?.chargingStatusLabel.text = "Charging in progress"
                        EGRootViewController.main?.showTabBarPage(0)
                        EGRootViewController.main?.presentTabBarVC()
                        EGRootViewController.main?.chargingStatusViewIsActive = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.chargingStatusLabel.text = "Rejected"
                    }
                }
            }
        }
        
    }
}
