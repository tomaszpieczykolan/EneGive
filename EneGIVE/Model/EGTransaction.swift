//
//  EneGIVE - EGTransaction.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

struct EGTransaction {
    
    var name: String
    var amount: Int
    var points: Int
    var transactionType: String
    var description: String
    var transactionCurrency: String
    var payUOrderStatus: String
    var payUUrl: String
    var completed: Bool
    
    init(_ dict: [AnyHashable: Any]) {
        name                = dict["Name"]                as? String ?? "nil"
        amount              = dict["Amount"]              as? Int    ?? -1
        points              = dict["Points"]              as? Int    ?? -1
        transactionType     = dict["TransactionType"]     as? String ?? "nil"
        description         = dict["Description"]         as? String ?? "nil"
        transactionCurrency = dict["TransactionCurrency"] as? String ?? "nil"
        payUOrderStatus     = dict["PayUORDERStatus"]     as? String ?? "nil"
        payUUrl             = dict["PayUUrl"]             as? String ?? "nil"
        completed           = dict["Completed"]           as! Bool
        
        EGModelValidation.validateGuard(#file, dict, name != "nil", amount != -1, points != -1, transactionType != "nil", description != "nil", transactionCurrency != "nil", payUOrderStatus != "nil", payUUrl != "nil")
    }
}
