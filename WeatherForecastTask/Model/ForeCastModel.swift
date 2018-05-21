//
//  ForeCastModel.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 21/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation

class ForeCastModel {
    
    /// Title of the weekday eg: Mon or Tue ...
    var dayTitle = ""
    
    /// Wheather Description of selected date eg: broken clouds..
    var weatherDescription = ""
    
    /// Weather Image URL Link
    var weatherImageURL = ""
    
    /// Current Temperature of city eg: 25°C
    var temperature = 0.0
    
    /// Current Wind speed in city eg: 2.0 m/s
    var windSpeed = 0.0
    
    /// Current Weather Humidity in city eg: 90.0 %
    var humidity = 0.0
    
    ///Current Weather Pressure in city eg: 90.0 %
    var pressure = 0.0
    
    let formatter = DateFormatter()
    
    
    struct Key {
        
        // weather
        static let weatherKey = "weather"
        static let icon = "icon"
        static let description = "description"
        
        //wind
        static let windKey = "wind"
        static let windSpeedKey = "speed"
        
        // temp
        static let weatherCondition = "main"
        static let tempKey = "temp"
        static let humidity = "humidity"
        static let pressure = "pressure"
        
    }

    
    init(foreCastDetails:[String:Any], dateTimeStamp:TimeInterval) {
        
        formatter.dateFormat = "EEE"
        dayTitle = formatter.string(from: Date(timeIntervalSince1970: dateTimeStamp))
        
        if let weatherArray = foreCastDetails[Key.weatherKey] as? [[String:Any]] {
            
            if weatherArray.count > 0 {
                
                if let descriptionData = weatherArray[0][Key.description] as? String {
                    
                    weatherDescription = descriptionData
                }
                
                if let imageIconData = weatherArray[0][Key.icon] as? String {
                    
                    weatherImageURL = imageIconData
                }
            }
        
        }
        
        if let windDict = foreCastDetails[Key.windKey] as? [String:Any] {
            
            if let windSpeedData = windDict[Key.windSpeedKey] as? Double {
                
                windSpeed = windSpeedData
            }
        }
        
        if let mainDict = foreCastDetails[Key.weatherCondition] as? [String:Any] {
            
            if let humidityData = mainDict[Key.humidity] as? Double {
                
                humidity = humidityData
            }
            
            if let pressureData = mainDict[Key.pressure] as? Double {
                
                pressure = pressureData
            }
            
            if let temperatureData = mainDict[Key.tempKey] as? Double {
                
                temperature = temperatureData - Kelvin_Temperature
            }
            
        }
    }

}
