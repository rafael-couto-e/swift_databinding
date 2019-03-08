//
//  InstallmentDetails.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import ObjectMapper

// MARK: class

class InstallmentDetails {
    
    // MARK: properties
    
    var overdueDays: String = ""
    var overdueDate: String = ""
    var originalValue: String = ""
    var valueDiff: String = ""
    var totalVale: String = ""
    var store: String = ""
    
    // MARK: initializers
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
}

// MARK: extensions

extension InstallmentDetails: Mappable {
    func mapping(map: Map) {
        self.overdueDays <- map["overdue_days"]
        self.overdueDate <- map["overdue_date"]
        self.originalValue <- map["original_value"]
        self.valueDiff <- map["value_diff"]
        self.totalVale <- map["total_value"]
        self.store <- map["store"]
    }
}
