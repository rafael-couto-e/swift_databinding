//
//  User.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import ObjectMapper

// MARK: class

class User {
    
    // MARK: properties
    
    var name: String = ""
    var overdue: String = ""
    var due: String = ""
    var installments: [Installment] = []
    var limits: Limits?
    
    // MARK: initializers
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
}

// MARK: extensions

extension User: Mappable {
    func mapping(map: Map) {
        self.name <- map["name"]
        self.overdue <- map["total_overdue"]
        self.due <- map["total_due"]
        self.installments <- map["installments"]
        self.limits <- map["limits"]
    }
}
