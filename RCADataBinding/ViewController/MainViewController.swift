//
//  ViewController.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARK: delegate protocols

protocol MainViewControllerDelegate: class {
    func didLogin(_ userData: User)
}

// MARK: class

class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: properties
    
    weak var delegate: MainViewControllerDelegate?
    fileprivate lazy var viewModel = { return MainViewModel() }()
    
    // MARK: parent functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindAndObserve()
    }
    
    // MARK: functions
    
    private func updateButtonStatus(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        
        self.confirmButton.isEnabled = enabled
        self.confirmButton.backgroundColor = UIColor(
            red: 0, green: 122/255,
            blue: 1, alpha: alpha
        )
    }
    
    private func bindAndObserve() {
        self.observe()
        self.bind()
    }
    
    private func bind() {
        usernameField.bind(to: viewModel.login)
        passwordField.bind(to: viewModel.password)
    }
    
    private func observe() {
        self.viewModel.mediator
            .with(source: self.viewModel.login)
            .and(source: self.viewModel.password)
            .mediate(self) { [weak self] str in
                self?.viewModel.mediator.value = self?.viewModel.shouldEnable
            }.andObserve { [weak self] enable in
                self?.updateButtonStatus(enabled: enable ?? false)
        }
        
        self.viewModel.error.observe(self) { error in
            self.errorAlert(title: "Atenção", message: error)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.showLoader()
        
        self.viewModel.authenticate().observe(self) { [weak self] user in
            self?.hideLoader()
            
            if let usr = user {
                self?.delegate?.didLogin(usr)
            }
        }
    }
}
