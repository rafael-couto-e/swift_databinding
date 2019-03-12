//
//  ApplicationCoordinator.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let loginCoordinator: LoginCoordinator
    
    init(window: UIWindow) {
        self.window = window
        
        self.rootViewController = UINavigationController()
        
        self.loginCoordinator = LoginCoordinator(presenter: rootViewController)
    }
    
    func start() {
        self.window.rootViewController = self.rootViewController
        
        self.loginCoordinator.start()
        
        self.window.makeKeyAndVisible()
    }
}
