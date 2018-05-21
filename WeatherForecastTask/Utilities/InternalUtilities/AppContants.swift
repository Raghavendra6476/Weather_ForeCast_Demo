//
//  AppContants.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import UIKit

let APP_NAME = "WeatherForecastTask"

let APP_COLOR:UIColor = #colorLiteral(red: 0.003921568627, green: 0.7098039216, blue: 0.9647058824, alpha: 1)
let APP_HIGHLIGHT_COLOR :UIColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)

let WINDOW_DELEGATE = UIApplication.shared.delegate?.window

let SCREEN_RECT = UIScreen.main.bounds

let SCREEN_SIZE = UIScreen.main.bounds.size

let SCREEN_WIDTH = WINDOW_DELEGATE??.frame.size.width

let SCREEN_HEIGHT = WINDOW_DELEGATE??.frame.size.height

let Kelvin_Temperature = 273.15


struct CORE_DATA {
    
    //Core Database constants
    static let WEATHER_DETAILS_ENTITY_NAME      = "WeatherDetails"
    
}

struct SegueIdetifiers {
    
    static let WeatherDetailsToCitiesVC         = "goToCitiesVC"
    static let WeatherDetailsToForeCastVC       = "goToForeCastVC"
}

struct USER_DEFAULTS {
    
    struct LOCATION {
        
        static let Latitude       = "latitude"
        static let Longitude      = "longitude"
        static let CurrentCityId  = "currentCityId"
    }
    
    struct SERVICE {
        
        static let ServiceCallTimeStamp  = "serviceCallTimeStamp"
        
    }
}



