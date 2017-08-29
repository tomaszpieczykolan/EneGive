//
//  EneGIVE - LaunchViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    convenience init() {
        self.init(nibName: "LaunchView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In the future we will try to authenticate the user here.
        
        let rootViewController = EGRootViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = rootViewController
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("LaunchViewController has finished.")
    }
}
