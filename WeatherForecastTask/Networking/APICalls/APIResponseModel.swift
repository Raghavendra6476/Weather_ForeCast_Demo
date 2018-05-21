//
//  APIManager.swift
//  Trustpals
//
//  Created by apple on 10/02/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit


///API Response Model
class APIResponseModel {
    
    var httpStatusCode:Int = 0
    
    /// Data in DIctionary format
    var data: [String: Any] = [:]
    
    
    init(statusCode:Int, dataResponse:[String:Any]) {
        
        httpStatusCode = statusCode
        data = dataResponse
    }
}

