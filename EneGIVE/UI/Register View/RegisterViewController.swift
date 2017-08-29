//
//  EneGIVE - RegisterViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var passwordConfirmLabel: UITextField!
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "RegisterView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    func tryToRegister() {
        guard
            let first = firstNameLabel.text,
            let last  = lastNameLabel.text,
            let email = emailLabel.text,
            let pass  = passwordLabel.text else {
                presentGenericAlert(title: "Error", message: "Please check all fields")
                return
        }
        
        guard first.characters.count > 0 else {
            presentGenericAlert(title: "Error", message: "First name is required")
            return
        }
        
        guard last.characters.count > 0 else {
            presentGenericAlert(title: "Error", message: "Last name is required")
            return
        }
        
        guard email.characters.count > 0 else {
            presentGenericAlert(title: "Error", message: "Email is required")
            return
        }
        
        guard pass.characters.count >= 8 else {
            presentGenericAlert(title: "Error", message: "Password needs to be at least 8 characters long")
            return
        }
        
        guard pass == passwordConfirmLabel.text else {
            presentGenericAlert(title: "Error", message: "Passwords don't match")
            return
        }
        
        AccountManager.shared.register(first: first, last: last, email: email, password: pass) { [weak self] (success) in
            self?.didRegister(successfully: success)
        }
    }
    
    
    
    // MARK: - User interaction
    
    @IBAction func signUpButtonPressed() {
        tryToRegister()
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func didRegister(successfully: Bool) {
        if successfully {
            presentGenericAlert(title: "Success", message: "Welcome to EneGive!") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        } else {
            presentGenericAlert(title: "Error", message: "There was a problem creating new account")
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameLabel:
            lastNameLabel.becomeFirstResponder()
        case lastNameLabel:
            emailLabel.becomeFirstResponder()
        case emailLabel:
            passwordLabel.becomeFirstResponder()
        case passwordLabel:
            passwordConfirmLabel.becomeFirstResponder()
        case passwordConfirmLabel:
            passwordConfirmLabel.resignFirstResponder()
            tryToRegister()
        default:
            break
        }
        return false
    }
}
