//
//  Installment.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import ObjectMapper

// MARK: class

class Installment {
    
    // MARK: properties
    
    var pastDue: String = ""
    var carnet: String = ""
    var installment: String = ""
    var value: String = ""
    var detail: InstallmentDetails?
    
    // MARK: initializers
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
}

// MARK: extensions

extension Installment: Mappable {
    func mapping(map: Map) {
        self.pastDue <- map["past_due"]
        self.carnet <- map["carnet"]
        self.installment <- map["installment"]
        self.value <- map["value"]
        self.detail <- map["detail"]
    }
}
