//
//  Extensions.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARL: NSObject

extension NSObject {
    func observe<T>(for liveData: LiveData<T>, with: @escaping (T) -> ()) {
        if let vc = liveData.owner?.vc {
            liveData.observe(vc) { value in
                if let val = value {
                    DispatchQueue.main.async { with(val) }
                }
            }
        }
    }
}

// MARK: Outlets

extension UITextField: BindingResolver {
    typealias BindingType = String
    
    func observingValue() -> String? {
        return self.text
    }
    
    func updateValue(with value: String) {
        self.text = value
    }
}

extension UISwitch: BindingResolver {
    typealias BindingType = Bool
    
    func observingValue() -> Bool? {
        return self.isOn
    }
    
    func updateValue(with value: Bool) {
        self.isOn = value
    }
}

extension UISlider: BindingResolver {
    typealias BindingType = Float
    
    func observingValue() -> Float? {
        return self.value
    }
    
    func updateValue(with value: Float) {
        self.value = value
    }
}

extension UIStepper: BindingResolver {
    typealias BindingType = Double
    
    func observingValue() -> Double? {
        return self.value
    }
    
    func updateValue(with value: Double) {
        self.value = value
    }
}
