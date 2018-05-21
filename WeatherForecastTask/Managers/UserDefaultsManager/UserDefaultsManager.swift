//
//  UserDefaultsManager.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    /// City Id details to show weather details, when app opens
    static var currentCityId:Int32 {
        
        if let cityId = UserDefaults.standard.value(forKey: USER_DEFAULTS.LOCATION.CurrentCityId) as? Int32 {
            
            return cityId
        }
        return 0
    
    }
    
    
    /// Latitude details to show weather details, when app opens
    static var prevLatitude : Double {
        
        if let prevLat = UserDefaults.standard.value(forKey: USER_DEFAULTS.LOCATION.Latitude) as? Double {
            
            return prevLat
        }
        return 0.0
        
    }
    
    /// Longitude details to show weather details, when app opens
    static var prevLongitude : Double {
        
        if let prevLong = UserDefaults.standard.value(forKey: USER_DEFAULTS.LOCATION.Longitude) as? Double {
            
            return prevLong
        }
        return 0.0
        
    }
    
    
    /// Service called timestamp details to maintain 10 minutes gap to call weather details service
    static var serviceCalledTimeStamp : TimeInterval {
        
        if let serviceCalledTimeStamp = UserDefaults.standard.value(forKey: USER_DEFAULTS.SERVICE.ServiceCallTimeStamp) as? TimeInterval {
            
            return serviceCalledTimeStamp
        }
        return 0
        
    }
}
