//
//  LiveData.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: class LiveData

class LiveData<T> {
    
    // MARK: properties
    public fileprivate (set) var value: T?
    fileprivate var observers: [(T?) -> Void] = []
    var owner: LifecycleOwner?
    
    // MARK: methods
    
    func observe(_ source: UIViewController, observer: @escaping (T?) -> Void) {
        self.owner = LifecycleOwner(owner: source)
        
        self.observers.append { [weak self] value in
            guard
                let owner = self?.owner
            else {
                return
            }
            
            if owner.shouldNotify {
                observer(value)
            }
        }
    }
}

// MARK: class MutableLiveData

class MutableLiveData<T>: LiveData<T> {
    
    // MARK: property
    
    override public var value: T? {
        get {
            return super.value
        }
        set {
            super.value = newValue
            
            for observer in super.observers {
                observer(newValue)
            }
        }
    }
}

// MARK: class MediatorLiveData

class MediatorLiveData<T>: MutableLiveData<T> {
    func addSource() {
        
    }
    
    func withSource() {
        
    }
}

// MARK: class Transformations

class Transformations {
    class func map() {
        
    }
    
    class func switchMap() {
        
    }
}

// MARK: class LifecycleOwner

class LifecycleOwner {
    
    // MARK: properties
    
    let vc: UIViewController
    
    // MARK: computed properties
    
    fileprivate var shouldNotify: Bool {
        return vc.isViewLoaded && !vc.isBeingDismissed
    }
    
    // MARK: initializers
    
    init(owner: UIViewController) {
        self.vc = owner
    }
}

// MARK: databinding resolvers

protocol BindingResolver: NSObjectProtocol {
    associatedtype BindingType: Equatable
    func observingValue() -> BindingType?
    func updateValue(with value: BindingType)
    func bind(to liveData: LiveData<BindingType>, callback: ((BindingType) -> Void)?)
}

extension BindingResolver where Self: NSObject {
    
    // MARK: properties
    
    private var binder: LiveData<BindingType> {
        get {
            guard
                let value = objc_getAssociatedObject(
                    self, &AssociatedKeys.binder
                ) as? LiveData<BindingType>
            else {
                let newValue = LiveData<BindingType>()
                
                objc_setAssociatedObject(
                    self, &AssociatedKeys.binder, newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                
                return newValue
            }
            
            return value
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self, &AssociatedKeys.binder, newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    // MARK: functions
    
    func setBinderValue(with value: BindingType?) {
        binder.value = value
    }
    
    func valueChanged() {
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
    
    func bind(to liveData: LiveData<BindingType>, callback: ((BindingType) -> Void)? = nil) {
        if let _self = self as? UIControl {
            _self.rx.controlEvent([.valueChanged, .editingChanged])
                .asObservable()
                .subscribe(onNext: { _ in
                    self.valueChanged()
                })
        }
        
        self.binder = liveData
        
        self.observe(for: liveData) { (value) in
            self.updateValue(with: value)
            callback?(value)
        }
    }
}

// MARK: structs

fileprivate struct AssociatedKeys {
    static var binder: UInt8 = 0
}
