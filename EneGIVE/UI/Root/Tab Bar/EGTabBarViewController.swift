//
//  EneGIVE - EGTabBarViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class EGTabBarViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.tintColor = Config.Color.primary
        self.tabBar.barTintColor = Config.Color.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mainViewController = MainViewController()
        let mainItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        mainViewController.tabBarItem = mainItem
        
        let mapViewController = MapViewController()
        let mapItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        mapViewController.tabBarItem = mapItem
        
        let accountViewController = AccountViewController()
        let accountItem = UITabBarItem(title: "Account", image: nil, selectedImage: nil)
        accountViewController.tabBarItem = accountItem
        
        let settingsViewController = SettingsViewController()
        let settingsItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
        settingsViewController.tabBarItem = settingsItem
        
        self.viewControllers = [mainViewController, mapViewController, accountViewController, settingsViewController]
    }
    
}

extension EGTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
