//
//  Extensions.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARK: enums

enum Storyboard: String {
    case main
    case launchScreen
    
    var identifier: String {
        return self.rawValue.capitalizingFirstLetter
    }
}

// MARK: protocols

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype ViewControllerType
    
    static func storyboardInstance(storyboard: Storyboard) -> ViewControllerType
}

// MARK: extensions

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension StoryboardInstantiable where Self: UIViewController {
    static func storyboardInstance(storyboard: Storyboard) -> Self {
        let storyboard = UIStoryboard(name: storyboard.identifier, bundle: nil)
        
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        else {
            fatalError("Could not instantiate ViewController")
        }
        
        return vc
    }
}

extension UIViewController: StoryboardInstantiable {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UINavigationController {
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool, completion: @escaping () -> Void
    ) {
        self.pushViewController(viewController, animated: animated)
        
        viewController.rx.methodInvoked(
            #selector(UIViewController.viewDidLoad)
        ).subscribe(onNext: { _ in
            completion()
        }).disposed(by: viewController.disposeBag)
    }
    
    func presentModally(
        _ viewController: UIViewController, removeBackground: Bool = true,
        animated: Bool, completion: @escaping () -> Void
    ) {
        viewController.modalPresentationStyle = .overCurrentContext
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if removeBackground {
            navigationController.modalPresentationStyle = .overCurrentContext
        }
        
        self.present(navigationController, animated: animated, completion: completion)
    }
    
    func popup(
        _ viewController: UIViewController, removeBackground: Bool = true,
        animated: Bool, completion: @escaping () -> Void
    ) {
        if removeBackground {
            viewController.modalPresentationStyle = .overCurrentContext
        } else {
            viewController.modalPresentationStyle = .popover
        }
        
        self.present(viewController, animated: animated, completion: completion)
    }
}
