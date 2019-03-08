//
//  DetailsViewModel.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import Foundation

class DetailsViewModel {
    
    // MARK: properties
    
    let user = MutableLiveData<User>()
    
    // MARK: computed properties
    
    var numberOfRows: Int {
        return user.value?.installments.count ?? 0
    }
    
    // MARK: functions
    
    func installment(for index: Int) -> Installment? {
        return user.value?.installments[index]
    }
}
