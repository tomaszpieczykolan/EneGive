//
//  EneGIVE - AddFundsViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class AddFundsViewController: UIViewController {
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "AddFundsView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func closeButtonPressed() {
        EGRootViewController.main?.presentTabBarVC()
    }
}
