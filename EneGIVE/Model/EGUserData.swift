//
//  EneGIVE - EGUserData.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

struct EGUserData {
    
    var email: String
    var firstName: String
    var lastName: String
    var balance: Decimal
    
    
    init(_ dict: [AnyHashable: Any]) {
        let balanceString =  dict["Balance"] as? String ?? "-1.0"
        
        email     = dict["Email"] as? String ?? "nil"
        firstName = dict["FirstName"] as? String ?? "nil"
        lastName  = dict["LastName"] as? String ?? "nil"
        balance   = Decimal(string: balanceString) ?? -1.0
        
        EGModelValidation.validateGuard(#file, dict, email != "nil", firstName != "nil", lastName != "nil", balance != -1.0)
    }
}
