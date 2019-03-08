//
//  ViewController.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARK: class

class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: properties
    
    fileprivate lazy var viewModel = { return MainViewModel() }()
    
    // MARK: parent functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.login.observe(self) { [weak self] newValue in
            self?.updateButtonStatus(enabled: self?.viewModel.shouldEnable ?? false)
        }
        
        self.viewModel.password.observe(self) { [weak self] newValue in
            self?.updateButtonStatus(enabled: self?.viewModel.shouldEnable ?? false)
        }
        
        self.viewModel.error.observe(self) { error in
            self.errorAlert(title: "Atenção", message: error)
        }
        
        usernameField.bind(to: viewModel.login)
        passwordField.bind(to: viewModel.password)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            guard
                let vc = segue.destination as? DetailsViewController
            else {
                return
            }
            
            vc.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
                .subscribe(
                    onNext: { [weak self] _ in
                        vc.viewModel.user.value = self?.viewModel.user.value
                    }
            )
        }
    }
    
    // MARK: functions
    
    func updateButtonStatus(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        
        self.confirmButton.isEnabled = enabled
        self.confirmButton.backgroundColor = UIColor(
            red: 0, green: 122/255,
            blue: 1, alpha: alpha
        )
    }
    
    // MARK: IBActions
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.showLoader()
        
        self.viewModel.authenticate().observe(self) { [weak self] _ in
            self?.hideLoader()
            self?.performSegue(withIdentifier: "goToDetails", sender: self)
        }
    }
}
