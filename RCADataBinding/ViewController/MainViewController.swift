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
    
    private let usernameField: UITextField = UITextField(frame: .zero)
    private let passwordField: UITextField = UITextField(frame: .zero)
    private let confirmButton: UIButton = UIButton(frame: .zero)
    private let scrollView: UIScrollView = UIScrollView(frame: .zero)
    
    // MARK: properties
    
    weak var delegate: MainViewControllerDelegate?
    fileprivate lazy var viewModel = { return MainViewModel() }()
    
    // MARK: parent functions
    
    // MARK: initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupConstraints()
        
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
        self.bind()
        self.observe()
    }
    
    private func setupLayout() {
        self.scrollView.addSubviews([
            self.usernameField,
            self.passwordField,
            self.confirmButton
        ])
        
        self.view.addSubviews([scrollView])
        
        self.usernameField.borderStyle = .roundedRect
        self.usernameField.placeholder = "Login"
        
        self.passwordField.borderStyle = .roundedRect
        self.passwordField.placeholder = "Senha"
        
        self.confirmButton.setTitle("Login", for: .normal)
        self.confirmButton.setTitleColor(.black, for: .normal)
        self.confirmButton.backgroundColor = UIColor(
            red: 0, green: 122/255,
            blue: 1, alpha: 0.5
        )
        
        self.view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        self.scrollView.top(to: self.view.safeAreaLayoutGuide.topAnchor, padding: 0)
        self.scrollView.leading(to: self.view.leadingAnchor, padding: 0)
        self.scrollView.trailing(to: self.view.trailingAnchor, padding: 0)
        self.scrollView.bottom(to: self.view.bottomAnchor, padding: 0)
        
        self.usernameField.centerX(to: scrollView)
        
        self.usernameField.top(to: self.scrollView.topAnchor, padding: 16)
        self.usernameField.leading(to: self.scrollView.leadingAnchor, padding: 16)
        self.usernameField.trailing(to: self.scrollView.trailingAnchor, padding: 16)
        self.usernameField.heigth(equalTo: 40)
        
        self.passwordField.top(to: self.usernameField.bottomAnchor, padding: 16)
        self.passwordField.leading(to: self.scrollView.leadingAnchor, padding: 16)
        self.passwordField.trailing(to: self.scrollView.trailingAnchor, padding: 16)
        self.passwordField.heigth(equalTo: 40)
        
        self.confirmButton.top(to: self.passwordField.bottomAnchor, padding: 16)
        self.confirmButton.leading(to: self.scrollView.leadingAnchor, padding: 16)
        self.confirmButton.trailing(to: self.scrollView.trailingAnchor, padding: 16)
        self.confirmButton.bottom(to: self.scrollView.bottomAnchor, padding: 16)
        
        self.confirmButton.heigth(equalTo: 40)
    }
    
    private func bind() {
        usernameField.bind(self, to: viewModel.login)
        passwordField.bind(self, to: viewModel.password)
        confirmButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
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
    
    // MARK: objc functions
    
    @objc private func didTapLogin() {
        self.showLoader()
        
        self.viewModel.authenticate().observe(self) { [weak self] user in
            self?.hideLoader()
            
            if let usr = user {
                self?.delegate?.didLogin(usr)
            }
        }
    }
}
