//
//  LoginCoordinator.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARK: class

class LoginCoordinator: Coordinator {
    
    // MARK: properties
    
    private let presenter: UINavigationController
    private var loginVc: MainViewController?
    private var detailsCoordinator: DetailsCoordinator?
    
    // MARK: initializers
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    // MARK: functions
    
    func start() {
        let loginVc = MainViewController.storyboardInstance(storyboard: .main)
        
        loginVc.title = "Login"
        loginVc.delegate = self
        
        self.presenter.pushViewController(loginVc, animated: true)
        
        self.loginVc = loginVc
    }
}

// MARK: extensions

extension LoginCoordinator: MainViewControllerDelegate {
    func didLogin(_ userData: User) {
        if self.detailsCoordinator == nil {
            let detailsCoordinator = DetailsCoordinator(presenter: self.presenter, userData: userData)
            self.detailsCoordinator = detailsCoordinator
        }
        
        self.detailsCoordinator?.start()
    }
}
