//
//  NetworkPromise.swift
//  GoodBoyTest
//
//  Created by wirawan on 25/8/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import PromiseKit
import Moya

class NetworkFuture<T> where T: Decodable {
    var network: Network!
    
    init(network: Network = Network()) {
        self.network = network
    }
    
    func request<U: GoodBoyTarget>(target: U) -> Promise<T> {
        return Promise { seal in
            self.network.request(target: target, success: { (data) in
                let decoder = JSONDecoder()
                do {
                    let value = try decoder.decode(T.self, from: data)
                    seal.fulfill(value)
                } catch {
                    seal.reject(Error.self as! Error)
                }
            }, error: { (error) in
                seal.reject(error)
            })
        }
    }
}

extension NetworkFuture where T == Data {
    func request<U: GoodBoyTarget>(target: U) -> Promise<Data> {
        return Promise { seal in
            self.network.request(target: target, success: { (data) in
                seal.fulfill(data)
            }, error: { (error) in
                seal.reject(error)
            })
        }
    }
}

