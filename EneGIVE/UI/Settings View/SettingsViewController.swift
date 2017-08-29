//
//  EneGIVE - SettingsViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum ReuseIdentifier {
        static let genericText = "EneGive-SettingsView-TableViewReuseIdentifier-GenericText"
        static let copyright = "EneGive-SettingsView-TableViewReuseIdentifier-Copyright"
    }
    
    
    
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingsItems: [SettingsItem] = [
        SettingsItem(id: "ToggleTopBar", title: "Toggle charging status bar".localized, selector: #selector(SettingsViewController.toggleTopBarCellPressed)),
        SettingsItem(id: "Help", title: "Help".localized, selector: #selector(SettingsViewController.helpCellPressed))
    ]
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "SettingsView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SettingsCellGenericText", bundle: nil), forCellReuseIdentifier: ReuseIdentifier.genericText)
        self.tableView.register(UINib(nibName: "SettingsCellCopyright",   bundle: nil), forCellReuseIdentifier: ReuseIdentifier.copyright)
        
        var loginItem: SettingsItem
        if AccountManager.shared.hasAccess {
            loginItem = SettingsItem(id: "SignOut", title: "Sign Out".localized, selector: #selector(SettingsViewController.signOutCellPressed))
        } else {
            loginItem = SettingsItem(id: "SignIn", title: "Sign In".localized, selector: #selector(SettingsViewController.signInCellPressed))
        }
        settingsItems.append(loginItem)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 29.0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        statusBarHeightConstraint.constant = topLayoutGuide.length
        tableView.contentInset.top = topLayoutGuide.length + 44.0
    }
    
    
    
    // MARK: - Actions
    
    func signInCellPressed() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func signOutCellPressed() {
        AccountManager.shared.logout()
        guard let itemID = self.settingsItems.index(where: { $0.id == "SignOut" }) else { return }
        settingsItems[itemID] = SettingsItem(id: "SignIn", title: "Sign In".localized, selector: #selector(SettingsViewController.signInCellPressed))
        tableView.reloadRows(at: [IndexPath(row: itemID, section: 0)], with: UITableViewRowAnimation.fade)
    }
    
    func helpCellPressed() {
        let helpViewController = HelpViewController()
        helpViewController.modalPresentationStyle = .overFullScreen
        present(helpViewController, animated: true, completion: nil)
    }
    
    func toggleTopBarCellPressed() {
        EGRootViewController.main?.chargingStatusViewIsActive = !(EGRootViewController.main?.chargingStatusViewIsActive ?? true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
        switch indexPath.section {
        case 0:
            self.perform(settingsItems[indexPath.row].selector)
        default:
            break
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settingsItems.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.genericText, for: indexPath) as! SettingsCellGenericText
            cell.title = settingsItems[indexPath.row].title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.copyright, for: indexPath) as! SettingsCellCopyright
            cell.selectionStyle = .none
            return cell
        default:
            fatalError()
        }
    }
}

extension SettingsViewController: LoginViewControllerDelegate {
    func loginViewController(didSuccessfullyAuthenticate success: Bool) {
        if success {
            if let itemID = self.settingsItems.index(where: { $0.id == "SignIn" }) {
                settingsItems[itemID] = SettingsItem(id: "SignOut", title: "Sign Out".localized, selector: #selector(SettingsViewController.signOutCellPressed))
                tableView.reloadRows(at: [IndexPath(row: itemID, section: 0)], with: UITableViewRowAnimation.fade)
            }
        }
    }
}
