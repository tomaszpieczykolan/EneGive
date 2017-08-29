//
//  EneGIVE - API.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation
import UIKit

enum API {
    enum APIError: Error {
        case unknown
        case statusCode
        case jsonSerialize
    }
    enum Account {
        enum Auth {
            static func login(username: String, password: String, completion: @escaping ((_ success: Bool) -> Void)) {
                guard let authString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else { return completion(false) }
                let headers = ["Authorization": "Basic \(authString)"]
                RestAPI.get("user/login", headers: headers) { (statusCode, data) in
                    guard let json = JSONUtility.serialize(data) as? [AnyHashable: Any] else { return completion(false) }
                    completion(json["status"] as? String == "Access granted")
                }
            }
        }
        
        static func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping ((_ success: Bool) -> Void)) {
            let body = [
                "firstname": firstName,
                "lastname":  lastName,
                "email":     email,
                "password":  password
            ]
            let headers = [
                "Content-Type": "application/json"
            ]
            RestAPI.post("user", body: body, headers: headers) { (statusCode, data) in
                guard let json = JSONUtility.serialize(data) as? [AnyHashable: Any] else { return completion(false) }
                completion(json["statusCode"] as? Int == 200)
            }
        }
        
        static func resetPassword(email: String, completion: @escaping ((_ success: Bool) -> Void)) {
            let body = ["Email": email]
            RestAPI.post("user/password/reset", body: body) { (statusCode, data) in
                guard statusCode == 200 else { return DispatchQueue.main.async { completion(false) } }
                DispatchQueue.main.async { completion(true) }
                
            }
        }
        
        static func userData(completion: @escaping ((_ success: Bool, _ userData: EGUserData?) -> Void)) {
            RestAPI.get("user", auth: true) { (statusCode, data) in
                guard statusCode == 200 else { return DispatchQueue.main.async { completion(false, nil) } }
                guard let json = JSONUtility.serialize(data) as? [AnyHashable: Any] else { return DispatchQueue.main.async { completion(false, nil) } }
                DispatchQueue.main.async { completion(true, EGUserData(json)) }
            }
        }
        
        static func transactions(completion: @escaping ((_ transactions: [EGTransaction]?, _ error: API.APIError?) -> Void)) {
            RestAPI.get("transaction/offset/0", auth: true) { (statusCode, data) in
                guard statusCode == 200 else { return DispatchQueue.main.async { completion(nil, API.APIError.statusCode) } }
                guard let json = JSONUtility.serialize(data) as? [[AnyHashable: Any]] else { return DispatchQueue.main.async { completion(nil, API.APIError.jsonSerialize) } }
                print(json)
                DispatchQueue.main.async { completion(json.map { EGTransaction($0) }, nil) }
            }
        }
    }
    
    static func location(completion: @escaping ((_ locations: [EGLocation]?, _ error: API.APIError?) -> Void)) {
        RestAPI.get("location") { (statusCode, data) in
            guard statusCode == 200                                               else { return completion(nil, API.APIError.statusCode) }
            guard let json = JSONUtility.serialize(data) as? [[AnyHashable: Any]] else { return completion(nil, API.APIError.jsonSerialize) }
            completion(json.map { EGLocation($0) }, nil)
        }
    }
    
    static func chargepoint(completion: @escaping ((_ chargepoints: [EGChargepoint]?, _ error: API.APIError?) -> Void)) {
        RestAPI.get("chargepoint") { (statusCode, data) in
            guard statusCode == 200                                               else { return completion(nil, API.APIError.statusCode) }
            guard let json = JSONUtility.serialize(data) as? [[AnyHashable: Any]] else { return completion(nil, API.APIError.jsonSerialize) }
            completion(json.map { EGChargepoint($0) }, nil)
        }
    }
    
    static func connector(locationID: String, completion: @escaping ((_ connectors: [EGConnector]?, _ error: API.APIError?) -> Void)) {
        RestAPI.get("connector/\(locationID)") { (statusCode, data) in
            guard statusCode == 200                                               else { return completion(nil, API.APIError.statusCode) }
            guard let json = JSONUtility.serialize(data) as? [[AnyHashable: Any]] else { return completion(nil, API.APIError.jsonSerialize) }
            completion(json.map { EGConnector($0) }, nil)
        }
    }
    
    enum Charge {
        enum ChargeError: Error {
            case missingChargePointID
            case missingConnectorID
            case unknown
        }
        
        static func start(chargePointID: String, connectorID: String, completion: @escaping ((_ status: String, _ error: Error?) -> Void)) {
            guard chargePointID.characters.count > 0 else { return completion("", API.Charge.ChargeError.missingChargePointID) }
            guard   connectorID.characters.count > 0 else { return completion("", API.Charge.ChargeError.missingConnectorID) }
            RestAPI.post("chargepoint/\(chargePointID)/startCharging", auth: true, parameters: ["connectorId": connectorID]) { (statusCode, data) in
                guard statusCode == 200 else { return completion("", API.APIError.statusCode) }
                guard let json = JSONUtility.serialize(data) as? [AnyHashable: Any] else { return completion("", API.APIError.jsonSerialize) }
                guard let status = json["status"] as? String else { return completion("", API.Charge.ChargeError.unknown) }
                completion(status, nil)
            }
        }
        
        static func stop(chargePointID: String, connectorID: String, completion: @escaping ((_ status: String, _ error: ChargeError?) -> Void)) {
            guard chargePointID.characters.count > 0 else { return completion("", API.Charge.ChargeError.missingChargePointID) }
            guard   connectorID.characters.count > 0 else { return completion("", API.Charge.ChargeError.missingConnectorID) }
            RestAPI.post("chargepoint/\(chargePointID)/stopCharging", auth: true, parameters: ["connectorId": connectorID]) { (statusCode, data) in
                guard statusCode == 200 else { return completion("", .unknown) }
                guard let json = JSONUtility.serialize(data) as? [AnyHashable: Any] else { return completion("", .unknown) }
                guard let payload = json["payload"] as? [AnyHashable: Any] else { return completion("", .unknown) }
                guard let status = payload["status"] as? String else { return completion("", .unknown) }
                completion(status, nil)
            }
        }
    }
}
