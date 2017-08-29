//
//  EneGIVE - HelpViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "HelpView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: -
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
