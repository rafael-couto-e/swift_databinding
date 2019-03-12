//
//  LoginCoordinator.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

class DetailsCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var detailsVc: DetailsViewController?
    private let userData: User
    
    init(presenter: UINavigationController, userData: User) {
        self.presenter = presenter
        self.userData = userData
    }
    
    func start() {
        let detailsVc = DetailsViewController.storyboardInstance(storyboard: .main)
        
        self.detailsVc = detailsVc
        
        detailsVc.title = "Detalhes"
        
        self.presenter.pushViewController(detailsVc, animated: true) { [weak self] in
            detailsVc.viewModel.user.value = self?.userData
        }
    }
}
