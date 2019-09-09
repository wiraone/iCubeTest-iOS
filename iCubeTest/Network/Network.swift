//
//  Network.swift
//  GoodBoyTest
//
//  Created by wirawan on 25/8/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import Moya
import Result

typealias GoodBoySuccessCompletion = (Data) -> Void
typealias GoodBoyErrorCompletion = (GoodBoyError) -> Void
typealias GoodBoyTarget = TargetType

struct GoodBoyAuthPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        let authorizationType = authorizable.authorizationType
        var request = request
        
        switch authorizationType {
        case .basic, .bearer:
            let authValue = "Bearer " + NetworkManager.sharedInstance.token
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
        case .none:
            break
        default:
            break
        }
        return request
    }
}


class Network {
    static var goodBoyProvider = MoyaProvider<GoodBoyAPI>(manager: NetworkManager.sharedInstance.manager,
                                                        plugins: [GoodBoyAuthPlugin()])
    
    
    func request<T: GoodBoyTarget>(target: T,
                                  success: @escaping GoodBoySuccessCompletion,
                                  error: @escaping GoodBoyErrorCompletion) {
        switch target {
        case is GoodBoyAPI:
            Network.goodBoyProvider.request(target as! GoodBoyAPI) { (result) in
                self.handleRequest(target: target,
                                   result: result,
                                   success: success,
                                   error: error)
            }
        default:
            assertionFailure("should not reach here")
        }
    }
    
    private func handleRequest<T: GoodBoyTarget>(target: T,
                                                result: Result<Moya.Response, MoyaError>,
                                                success: @escaping GoodBoySuccessCompletion,
                                                error: @escaping GoodBoyErrorCompletion) {
        
        
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            switch statusCode {
            case 200...399:
                success(data)
            default:
                handleNetworkError(target.path, error: error, response: moyaResponse)
            }
        case let .failure(networkError):
            var errorContent: GoodBoyErrorContent = GoodBoyErrorContent()
            errorContent.code = String(networkError.response?.statusCode ?? -1)
            errorContent.message = networkError.localizedDescription
            
            var goodBoyError = GoodBoyError()
            goodBoyError.error = errorContent
            error(goodBoyError)
        }
    }
    
    private func handleNetworkError(_ path: String,
                                    error: GoodBoyErrorCompletion,
                                    response: Moya.Response?) {
        let networkError = generateError(with: response)
        error(networkError)
    }
    
    private func generateError(with response: Moya.Response?) -> GoodBoyError {
        do {
            let json = try? JSONSerialization.jsonObject(with: response?.data ?? Data(), options: [])
            print("response %@", json.debugDescription)
            var errorContent = GoodBoyErrorContent()
            errorContent.message = json.debugDescription
            var error = GoodBoyError()
            error.error = errorContent
            return error
        } catch {
            let dataString = String(data: response?.data ?? Data(), encoding: String.Encoding.utf8)
            var errorContent = GoodBoyErrorContent()
            errorContent.message = dataString
            var error = GoodBoyError()
            error.error = errorContent
            return error
        }
    }
}
