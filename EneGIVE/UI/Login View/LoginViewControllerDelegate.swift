//
//  EneGIVE - LoginViewControllerDelegate.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

protocol LoginViewControllerDelegate: class {
    
    func loginViewController(didSuccessfullyAuthenticate success: Bool)
}
