//
//  Limits.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import ObjectMapper

// MARK: class
class Limits {
    
    // MARK: properties
    
    var totalDue: String = ""
    var total: String = ""
    var expent: String = ""
    var available: String = ""
    
    // MARK: initializers
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
}

// MARK: extensions

extension Limits: Mappable {
    func mapping(map: Map) {
        self.totalDue <- map["total_due"]
        self.total <- map["total"]
        self.expent <- map["expent"]
        self.available <- map["available"]
    }
}
