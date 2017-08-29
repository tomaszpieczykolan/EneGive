//
//  EneGIVE - AccountManager.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation
import UIKit

class AccountManager {
    
    static let shared = AccountManager()
    
    private(set) var username: String? {
        didSet {
            if oldValue != username {
                UserDefaults.standard.set(username, forKey: "EneGIVE-Auth-Username")
            }
        }
    }
    private var password: String? {
        didSet {
            if oldValue != password {
                UserDefaults.standard.set(password, forKey: "EneGIVE-Auth-Password")
            }
        }
    }
    var authString: String? {
        guard let user = username, let pass = password else { return nil }
        return "\(user):\(pass)".data(using: .utf8)?.base64EncodedString()
    }
    
    var hasAccess: Bool {
        return (username != nil && password != nil)
    }
    
    var userData: EGUserData? {
        didSet {
            EGRootViewController.main?.userData = userData
        }
    }
    var selectedLocation: EGLocation?
    var selectedConnector: EGConnector?
    
    
    
    private init() {
        if let username = UserDefaults.standard.string(forKey: "EneGIVE-Auth-Username"), let password = UserDefaults.standard.string(forKey: "EneGIVE-Auth-Password") {
            self.username = username
            self.password = password
            DispatchQueue.global().async {
                API.Account.userData(completion: { (success, userData) in
                    self.userData = userData
                })
            }
        }
    }
    
    
    
    func login(email: String, password: String, completion: @escaping ((_ success: Bool) -> Void)) {
        API.Account.Auth.login(username: email, password: password) { (success) in
            if success {
                self.username = email
                self.password = password
                API.Account.userData(completion: { (success, userData) in
                    self.userData = userData
                })
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func register(first: String, last: String, email: String, password: String, completion: @escaping ((_ success: Bool) -> Void)) {
        API.Account.register(firstName: first, lastName: last, email: email, password: password) { (success) in
            if success {
                self.username = email
                self.password = password
                API.Account.userData(completion: { (success, userData) in
                    self.userData = userData
                })
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func logout() {
        self.username = nil
        self.password = nil
    }
}
