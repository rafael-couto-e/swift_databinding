//
//  LoginService.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import Foundation

struct LoginService {
    static func loadUserData(
        password: String,
        success: @escaping (_ data: User) -> Void,
        failure: @escaping (_ error: String) -> Void
    ) {
        Network.get(url: .login, type: User.self, params: ["pwd": password]) { result in
            switch result {
            case let .success(data):
                success(data)
            case let .failure(error):
                failure(error)
            }
        }
    }
}
