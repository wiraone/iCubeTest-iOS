//
//  API.swift
//  GoodBoyTest
//
//  Created by wirawan on 25/8/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import Moya

struct APIConstant {
    static let baseURL = "https://my-json-server.typicode.com/wiraone/iCubeTest"
}


enum GoodBoyAPI {
    case getPlaces
}

// MARK: - TargetType Protocol Implementation
extension GoodBoyAPI: GoodBoyTarget {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPlaces:
            return "/db"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}

extension GoodBoyAPI: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        switch self {
        case .getPlaces:
            return .bearer
        }
    }
}

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


