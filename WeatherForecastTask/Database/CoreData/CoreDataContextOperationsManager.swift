//
//  CoreDataOperationsManager.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContextOperationsManager  {
    
    /// Singleton Object of CoreDataContextOperationsManager class
    static let sharedInstance = CoreDataContextOperationsManager()
    
    /// Singleton Object of CoreDataManager class
    let coreDataManager = CoreDataManager.sharedInstance
    
    
    /// Method to insert weather details to coredata
    ///
    /// - Parameters:
    ///   - cityId: city id value
    ///   - weatherDetails: weather forecast details
    func insertWeatherDetailsToDatabase(cityId:Int32, weatherDetails:Any) {
        
        let context = coreDataManager.persistentContainer.viewContext
        
        let currentWeatherDetailsArray = fetchParticularCityWeatherDetails(cityId: cityId)
        
        //Checking city id is already exist in database
        if currentWeatherDetailsArray.count > 0 {
            
            //Updating weather details in database
            if let currentWeatherDetails = currentWeatherDetailsArray[0] as? WeatherDetails {
                
                currentWeatherDetails.weatherDetails = weatherDetails as? NSObject
            }
            
        } else {
            
            //Creating New row in database and inserting weather details data
            let newWeatherDetails = WeatherDetails(context: context)
            
            newWeatherDetails.cityId = cityId
            newWeatherDetails.weatherDetails = weatherDetails as? NSObject

        }
        
        // Save the data to coredata
        coreDataManager.saveContext()
        
    }
    
    
    /// Method to fetch particular city weather details from database using cityId
    ///
    /// - Parameter cityId: city id to get weather details
    /// - Returns: array Of Weather details stored in coredata
    func fetchParticularCityWeatherDetails(cityId:Int32) -> [Any] {
        
        let context = coreDataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: CORE_DATA.WEATHER_DETAILS_ENTITY_NAME)
        
        let predicate = NSPredicate.init(format: "cityId == %d", cityId)
        
        fetchRequest.predicate = predicate
        
        do {
            
            let weatherDetails = try context.fetch(fetchRequest)
            
            if weatherDetails.count > 0 {
                
                 return weatherDetails
            } else {
                
                 return []
            }

        }
        catch {
            
            print("Fetching Failed")
            
        }
        return []
    }
    
    
    /// Method to delete particular city weather details from database using cityId
    ///
    /// - Parameter cityId: city id to delete weather details
    func deleteParticularCityWeatherDetails(cityId:Int32) {
        
        let context = coreDataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: CORE_DATA.WEATHER_DETAILS_ENTITY_NAME)
        
        let predicate = NSPredicate.init(format: "cityId == %d", cityId)
        
        fetchRequest.predicate = predicate
        
        do {
            
            let weatherDetails = try context.fetch(fetchRequest)
            
            for eachWeatherDetail in weatherDetails {
                
                context.delete(eachWeatherDetail as! NSManagedObject)
            }
            
            // Save the data to coredata
            coreDataManager.saveContext()
        }
        catch {
            
            print("Fetching Failed")
            
        }
    }
    
    
    /// Method to delete all city weather details from database
    func deleteAllCitiesWeatherDetails() {
        
        let context = coreDataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: CORE_DATA.WEATHER_DETAILS_ENTITY_NAME)
        
        do {
            
            let weatherDetails = try context.fetch(fetchRequest)
            
            for eachWeatherDetail in weatherDetails {
                
                context.delete(eachWeatherDetail as! NSManagedObject)
            }
            
            // Save the data to coredata
            coreDataManager.saveContext()
            
        }
        catch {
            
            print("Fetching Failed")
            
        }
    }
    
}
