//
//  MainViewModel.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import Foundation

// MARK: class

class MainViewModel {
    
    // MARK: properties
    
    private let _login = MutableLiveData<String>()
    var login: LiveData<String> { return self._login }
    
    private let _password = MutableLiveData<String>()
    var password: LiveData<String> { return self._password }
    
    private let _error = MutableLiveData<String>()
    var error: LiveData<String> { return _error }
    
    let mediator = MediatorLiveData<Bool>()
    
    // MARK: computed properties
    
    var shouldEnable: Bool {
        let (login, password) = self.validLoginAndPassword()
        
        return !(login.isEmpty || password.isEmpty)
    }
    
    // MARK: methods
    
    private func validLoginAndPassword() -> (login: String, password: String) {
        if let login = self._login.value {
            if let password = self._password.value {
                return (login, password)
            }
        }
        
        return ("", "")
    }
    
    func authenticate() -> LiveData<User> {
        let (_, password) = self.validLoginAndPassword()
        
        let user = MutableLiveData<User>()
        
        LoginService.loadUserData(
            password: password,
            success: { result in
                user.value = result
            }, failure: { [weak self] error in
                self?._error.value = error
            }
        )
        
        return user
    }
}
