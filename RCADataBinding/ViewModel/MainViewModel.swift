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
    
    let login = MutableLiveData<String>()
    let password = MutableLiveData<String>()
    let error = MutableLiveData<String>()
    let user = MutableLiveData<User>()
    
    // MARK: computed properties
    
    var shouldEnable: Bool {
        let (login, password) = self.validLoginAndPassword()
        
        return !(login.isEmpty || password.isEmpty)
    }
    
    // MARK: methods
    
    private func validLoginAndPassword() -> (login: String, password: String) {
        if let login = self.login.value {
            if let password = self.password.value {
                return (login, password)
            }
        }
        
        return ("", "")
    }
    
    func authenticate() -> LiveData<User> {
        let (_, password) = self.validLoginAndPassword()
        
        LoginService.loadUserData(
            password: password,
            success: { [weak self] user in
                self?.user.value = user
            }, failure: { [weak self] error in
                self?.error.value = error
            }
        )
        
        return self.user
    }
}
