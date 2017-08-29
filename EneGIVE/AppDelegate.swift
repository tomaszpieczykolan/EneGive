//
//  EneGIVE - AppDelegate.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let launchViewController = LaunchViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.rootViewController = launchViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
