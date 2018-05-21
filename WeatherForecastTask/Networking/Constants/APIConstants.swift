//
//  APIConstants.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation

struct API
{
    static let BASE_URL             = "http://api.openweathermap.org/data/2.5/"
    static let IMAGE_BASE_URL       = "http://openweathermap.org/img/w/"
    
    static var WeatherAPIKey: String {
        
        get {
            return Helper.readConfigurationValue("weatherApiKey", file: "API", type: "plist")
        }
    }
    
    //API Method Names
    struct METHOD {
        
        static let WeatherDetails           =   "weather"
        static let ForeCastDetails          =   "forecast"

    }
    
}
