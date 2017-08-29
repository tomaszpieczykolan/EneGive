//
//  EneGIVE - EGRootViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class EGRootViewController: UIViewController {
    
    static var main: EGRootViewController? {
        return ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? EGRootViewController)
    }
    
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chargingStatusView: UIView!
    @IBOutlet weak var addFundsView: UIView!
    private weak var chargingStatusHeightConstraint: NSLayoutConstraint?
    private weak var addFundsHeightConstraint: NSLayoutConstraint?
    var chargingStatusViewIsActive: Bool {
        set {
            guard newValue != chargingStatusViewIsActive else { return }
            // this is super fucking stupid
            DispatchQueue.main.async {
                if newValue {
                    self.chargingStatusHeightConstraint = NSLayoutConstraint(item: self.chargingStatusView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 66.0)
                    self.chargingStatusView.addConstraint(self.chargingStatusHeightConstraint!)
                } else {
                    guard let constraint = self.chargingStatusHeightConstraint else { return }
                    self.chargingStatusView.removeConstraint(constraint)
                    self.chargingStatusHeightConstraint = nil
                }
                
                UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.75, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
        }
        get {
            return chargingStatusHeightConstraint != nil
        }
    }
    var addFundsViewIsActive: Bool {
        set {
            guard newValue != addFundsViewIsActive else { return }
            // this is super fucking stupid
            DispatchQueue.main.async {
                if newValue {
                    guard let constraint = self.addFundsHeightConstraint else { return }
                    self.addFundsView.removeConstraint(constraint)
                    self.addFundsHeightConstraint = nil
                } else {
                    self.addFundsHeightConstraint = NSLayoutConstraint(item: self.addFundsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
                    self.addFundsView.addConstraint(self.addFundsHeightConstraint!)
                }
                
                UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.75, animations: {
                    self.view.layoutIfNeeded()
                }).startAnimation()
            }
        }
        get {
            return addFundsHeightConstraint == nil
        }
    }
    @IBOutlet weak var separatorLineView: UIView!
    private var viewControllers = [UIViewController]()
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    var userData: EGUserData? {
        didSet {
            guard let newValue = userData else { return }
            helloLabel.text = "Hello, \(newValue.firstName) \(newValue.lastName)!"
            balanceLabel.text = newValue.balance.balanceFormatted
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "EGRootView", bundle: nil)
        
        let tabBarVC: EGTabBarViewController = {
            let vc = EGTabBarViewController()
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            return vc
        }()
        
        let chargeVC: ChargeViewController = {
            let vc = ChargeViewController()
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            return vc
        }()
        
        let addFundsVC: AddFundsViewController = {
            let vc = AddFundsViewController()
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            return vc
        }()
        
        viewControllers = [tabBarVC, chargeVC, addFundsVC]
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for vc in viewControllers {
            addChildViewController(vc)
            view.addSubview(vc.view)
            view.addConstraints([
                NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: vc.view, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: vc.view, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: vc.view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: separatorLineView, attribute: .bottom, relatedBy: .equal, toItem: vc.view, attribute: .top, multiplier: 1.0, constant: 0.0)
            ])
        }
        
        presentVC(0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        statusBarHeightConstraint.constant = topLayoutGuide.length
    }
    
    
    
    // MARK: -
    
    @IBAction func showChargeViewButtonPressed() {
        presentVC(1)
        chargingStatusViewIsActive = false
    }
    
    @IBAction func addFundsButtonPressed() {
        presentVC(2)
    }
    
    func presentTabBarVC() {
        presentVC(0)
    }
    
    func presentChargeVC() {
        presentVC(1)
    }
    
    private func presentVC(_ index: Int) {
        view.bringSubview(toFront: viewControllers[index].view)
        viewControllers[index].viewDidAppear(false)
        addFundsViewIsActive = index != 2
    }
    
    func showTabBarPage(_ index: Int) {
        (self.viewControllers[0] as? EGTabBarViewController)?.selectedIndex = index
    }
}
