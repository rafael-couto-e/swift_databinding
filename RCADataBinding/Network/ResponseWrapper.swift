//
//  ResponseWrapper.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import ObjectMapper

// MARK: class

class ResponseWrapper<T: Mappable>: Mappable {
    
    // MARK: properties
    
    var code: Int = 0
    var status: String = ""
    var data: T?
    
    // MARK: initializers
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    // MARK: functions
    
    func mapping(map: Map) {
        self.code <- map["code"]
        self.status <- map["status"]
        self.data <- map["data"]
    }
}
