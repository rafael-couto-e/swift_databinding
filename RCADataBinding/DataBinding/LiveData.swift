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
    fileprivate var sources: [Any] = []
    
    func add<S>(source: LiveData<S>, observer: @escaping (S?) -> Void) {
        if let vc = source.owner?.vc {
            source.observe(vc, observer: observer)
        }
    }
    
    func with<S>(source: LiveData<S>) -> MediatorLiveDataChain<T, S> {
        self.sources.append(source)
        
        return MediatorLiveDataChain(mediator: self)
    }
    
    func with<S>(source: LiveData<S>, observer: @escaping (S?) -> Void) -> MediatorLiveData<T> {
        self.add(source: source, observer: observer)
        
        return self
    }
}

class MediatorLiveDataChain<T, S> {
    private let mediator: MediatorLiveData<T>
    private var owner: LifecycleOwner?
    
    init(mediator: MediatorLiveData<T>) {
        self.mediator = mediator
    }
    
    func and(source: LiveData<S>) -> MediatorLiveDataChain<T, S> {
        self.mediator.sources.append(source)
        
        return self
    }
    
    func mediate(_ owner: UIViewController, observer: @escaping (S?) -> Void) -> MediatorLiveDataChain<T, S> {
        self.owner = LifecycleOwner(owner: owner)
        
        for source in self.mediator.sources {
            if let src = source as? LiveData<S> {
                src.observe(owner, observer: observer)
            }
        }
        
        return self
    }
    
    func andObserve(observer: @escaping (T?) -> Void) {
        if let owner = self.owner?.vc {
            self.mediator.observe(owner, observer: observer)
        }
    }
}

// MARK: class Transformations

class Transformations {
    class func map<S, T>(
        _ owner: UIViewController,
        source: LiveData<S>,
        callback: @escaping (S) -> T
    ) -> LiveData<T> {
        let result = MediatorLiveData<T>()
        
        if source.owner == nil {
            source.owner = LifecycleOwner(owner: owner)
        }
        
        if result.owner == nil {
            result.owner = LifecycleOwner(owner: owner)
        }
        
        result.add(source: source) { _s in
            if let s = _s { result.value = callback(s) }
        }
        
        return result
    }
    
    /*class func switchMap<T, S>(
        _ owner: UIViewController, source: LiveData<T>,
        callback: @escaping (T) -> LiveData<S>
    ) -> LiveData<S> {
        let result = MediatorLiveData<S>()
        
        if source.owner == nil {
            source.owner = LifecycleOwner(owner: owner)
        }
        
        if result.owner == nil {
            result.owner = LifecycleOwner(owner: owner)
        }
        
        result.add(source: source) { _t in
            var ld: LiveData<S>?
            
            if let t = _t {
                let newLd = callback(t)
                
                if ld === newLd { return }

                ld = newLd
                
                if let _ld = ld {
                    result.add(source: _ld) { _s in
                        result.value = _s
                    }
                }
            }
        }
        
        return result
    }*/
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
    func bind(_ owner: UIViewController, to liveData: LiveData<BindingType>, callback: ((BindingType) -> Void)?)
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
    
    func bind(
        _ owner: UIViewController,
        to liveData: LiveData<BindingType>,
        callback: ((BindingType) -> Void)? = nil
    ) {
        if let _self = self as? UIControl {
            _self.rx.controlEvent([.valueChanged, .editingChanged])
                .asObservable()
                .subscribe(onNext: { _ in
                    self.valueChanged()
                }).disposed(by: owner.disposeBag)
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
