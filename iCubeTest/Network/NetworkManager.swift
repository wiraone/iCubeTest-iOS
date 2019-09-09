//
//  NetworkManager.swift
//  GoodBoyTest
//
//  Created by wirawan on 25/8/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static var sharedInstance: NetworkManager = NetworkManager()
    
    let manager = SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: nil
    )
    
    var token: String {
        return ""
    }
}
