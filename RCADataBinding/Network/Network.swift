//
//  Network.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

// MARK: enum

enum Result<T> {
    case success(_ data: T)
    case failure(_ error: String)
}

// MARK: class

struct Network {
    
    // MARK: functions
    
    static func get<T: Mappable>(
        url: String, type: T.Type, params: [String: Any],
        callback: @escaping (Result<T>) -> Void
    ) {
        Alamofire.request(
            url, method: .get, parameters: params,
            encoding: URLEncoding.queryString, headers: nil
        ).responseObject { (response: DataResponse<ResponseWrapper<T>>) in
            switch response.result {
            case let .success(value):
                if value.code == 200 {
                    guard let data = value.data else {
                        callback(.failure("Impossible to deserialize Data."))
                        return
                    }
                    
                    callback(.success(data))
                } else {
                    callback(.failure(value.status))
                }
            case let .failure(error):
                callback(.failure(error.localizedDescription))
            }
        }
    }
}
