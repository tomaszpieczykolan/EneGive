//
//  EneGIVE - UIViewControllerExtensions.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentGenericAlert(title: String, message: String, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            okHandler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
