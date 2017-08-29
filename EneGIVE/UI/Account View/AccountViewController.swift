//
//  EneGIVE - AccountViewController.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    
    enum ReuseIdentifier {
        static let transaction = "EneGive-AccountView-TableViewReuseIdentifier-Transaction"
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var transactions: [EGTransaction]?
    
    
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: "AccountView", bundle: nil)
    }
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "EGTransactionCell", bundle: nil), forCellReuseIdentifier: ReuseIdentifier.transaction)
        
        API.Account.transactions { [weak self] (transactions, error) in
            guard error == nil else { return }
            self?.transactions = transactions
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset.bottom = 49.5
        tableView.scrollIndicatorInsets.bottom = 49.5
    }
    
    
    
    // MARK: -
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AccountViewController: UITableViewDelegate {
    
}

extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.transactions?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.transaction, for: indexPath) as! EGTransactionCell
        
        if let transaction = transactions?[safe: indexPath.row] {
            cell.nameLabel.text = transaction.name
        }
        
        return cell
    }
}
