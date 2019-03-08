//
//  UIViewControllerExtensions.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit
import PKHUD

// MARK: extensions

extension UIViewController {
    func showLoader() {
        HUD.show(.progress)
    }
    
    func hideLoader() {
        HUD.hide()
    }
    
    func errorAlert(title: String?, message: String?) {
        self.hideLoader()
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true)
    }
}
