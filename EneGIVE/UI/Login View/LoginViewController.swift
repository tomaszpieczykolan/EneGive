//
//  EneGIVE - LoginViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "LoginView", bundle: nil)
    }
    
    
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.emailTextField.isHidden = AccountManager.shared.hasAccess
        self.passwordTextField.isHidden = AccountManager.shared.hasAccess
        
        super.viewWillAppear(animated)
    }
    
    
    
    // MARK: - User interaction
    
    @IBAction func loginButtonPressed() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            showActivityIndicator()
            
            AccountManager.shared.login(email: email, password: password, completion: { [weak self] (success) in
                self?.removeActivityIndicator()
                if success {
                    self?.delegate?.loginViewController(didSuccessfullyAuthenticate: true)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.presentGenericAlert(title: "Error".localized, message: "Could not authenticate")
                }
            })
        }
    }
    
    @IBAction func registerButtonPressed() {
        
        let registerViewController = RegisterViewController()
        
        registerViewController.modalTransitionStyle = .coverVertical
        
        self.present(registerViewController, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonPressed() {
        
        let resetPasswordViewController = ResetPasswordViewController()
        
        resetPasswordViewController.modalTransitionStyle = .coverVertical
        
        self.present(resetPasswordViewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed() {
        delegate?.loginViewController(didSuccessfullyAuthenticate: false)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - UIActivityIndicatorView
    
    var activityIndicatorView: UIActivityIndicatorView?
    var activityIndicatorViewConstraints: [NSLayoutConstraint]?
    
    func showActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        guard let indicator = activityIndicatorView else { return }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        activityIndicatorViewConstraints = [
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ]
        if let constraints = activityIndicatorViewConstraints {
            view.addConstraints(constraints)
        }
        indicator.startAnimating()
    }
    
    func removeActivityIndicator() {
        activityIndicatorView?.stopAnimating()
        if let constraintsToRemove = activityIndicatorViewConstraints {
            view.removeConstraints(constraintsToRemove)
        }
        activityIndicatorViewConstraints = nil
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
    }
}
