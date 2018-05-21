//
//  CityModel.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation

class CityModel {
    
    var cityId:Int32 = 0
    var cityName = ""
    
    init(cityDetails:[String:Any]) {
        
        if let cityIdData = cityDetails["id"] as? Int32 {
            
            cityId = cityIdData
        }
        
        if let cityNameData = cityDetails["name"] as? String {
            
            cityName = cityNameData
        }
        
    }
}
