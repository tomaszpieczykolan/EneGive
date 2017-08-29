//
//  EneGIVE - ResetPasswordViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "ResetPasswordView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    @IBAction func resetButtonPressed() {
        guard let email = emailTextField.text, email.characters.count > 0 else {
            presentGenericAlert(title: "Error", message: "Email field can't be empty")
            return
        }
        API.Account.resetPassword(email: email) { [weak self] (success) in
            if success {
                self?.emailTextField.text = nil
                self?.presentGenericAlert(title: "Success", message: "Please check your email")
            } else {
                self?.presentGenericAlert(title: "Error", message: "There was a problem resetting your password")
            }
        }
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
