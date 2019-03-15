//
//  DetailsViewModel.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

class DetailsViewModel {
    
    // MARK: properties
    
    let user = MutableLiveData<User>()
    
    let username: LiveData<String>
    let available: LiveData<String>
    let total: LiveData<String>
    let expent: LiveData<String>
    let items: LiveData<[Installment]>
    
    // MARK: initializers
    
    init(_ vc: UIViewController) {
        self.username = Transformations.map(vc, source: user) { $0.name }
        self.available = Transformations.map(vc, source: user) { $0.limits?.available ?? "" }
        self.total = Transformations.map(vc, source: user) { $0.limits?.total ?? "" }
        self.expent = Transformations.map(vc, source: user) { $0.limits?.expent ?? "" }
        self.items = Transformations.map(vc, source: user) { $0.installments }
    }
    
    // MARK: computed properties
    
    var numberOfRows: Int {
        return user.value?.installments.count ?? 0
    }
    
    // MARK: functions
    
    func installment(for index: Int) -> Installment? {
        return user.value?.installments[index]
    }
}
