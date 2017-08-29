//
//  EneGIVE - RestAPI.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

enum RestAPI {
    
    // MARK: - Configuration
    
    fileprivate static let endpointBase = "https://clorcepowerapi-test.herokuapp.com/"
    
    
    
    // MARK: - Requests
    
    static func get(_ urlString: String, auth: Bool = false, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping ((_ statusCode: Int, _ data: Data?) -> Void)) {
        self.httpRequestDebug(method: "GET", urlString, auth: auth, parameters: parameters, body: nil, headers: headers, completion: completion)
    }
    
    static func post(_ urlString: String, auth: Bool = false, parameters: [String: String]? = nil, body: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping ((_ statusCode: Int, _ data: Data?) -> Void)) {
        self.httpRequestDebug(method: "POST", urlString, auth: auth, parameters: parameters, body: body, headers: headers, completion: completion)
    }
    
    static func put(_ urlString: String, auth: Bool = false, parameters: [String: String]? = nil, body: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping ((_ statusCode: Int, _ data: Data?) -> Void)) {
        self.httpRequestDebug(method: "PUT", urlString, auth: auth, parameters: parameters, body: body, headers: headers, completion: completion)
    }
    
    fileprivate static func httpRequestDebug(method: String, _ urlString: String, auth: Bool = false, parameters: [String: String]?, body: [String: String]?, headers: [String: String]?, completion: @escaping ((_ statusCode: Int, _ data: Data?) -> Void)) {
        httpRequest(method: method, urlString, auth: auth, parameters: parameters, body: body, headers: headers) { (statusCode: Int, data: Data?) in
            print("Status code: \(statusCode)")
            completion(statusCode, data)
        }
    }
    
    
    
    // MARK: - Generic request
    
    fileprivate static func httpRequest(method: String, _ urlString: String, auth: Bool = false, parameters: [String: String]?, body: [String: String]?, headers: [String: String]?, completion: @escaping ((_ statusCode: Int, _ data: Data?) -> Void)) {
        var parametersString = ""
        if let parameters = parameters {
            parametersString += "?"
            for parameter in parameters {
                parametersString += "\(parameter.key)=\(parameter.value)&"
            }
            parametersString.characters.removeLast()
        }
        guard let url = URL(string: "\(endpointBase)\(urlString)\(parametersString)") else {
            completion(-1, nil)
            return
        }
        print("\(method) link: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if auth {
            guard let authString = AccountManager.shared.authString else {
                completion(-1, nil)
                return
            }
            request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        }
        
        if let headersUnwrapped = headers {
            for header in headersUnwrapped {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let httpBody = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let e = error {
                let statusCode = -1
                print("Error from response: \(e)")
                completion(statusCode, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let statusCode = -1
                print("Response cast error")
                completion(statusCode, nil)
                return
            }
            
            completion(httpResponse.statusCode, data)
        }
        task.resume()
    }
}
