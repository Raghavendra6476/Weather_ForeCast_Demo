//
//  WeatherDetailsViewModel.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherDetailsViewModel {
    
    let rxWeatherDetailsAPICall = WeatherDetailsAPI()
    let disposebag = DisposeBag()
    var arrayOfForeCastModel = [ForeCastModel]()

    /// Method to get Current city Weather details from Current location
    ///
    /// - Parameter completion: array Of Forecast details
    func getCurrentCityWeatherDetails(completion:@escaping ([ForeCastModel]) -> ()) {
        
        //Check city Data in Coredatabase, if data is there check condition for 10 min
        if LocationManager.sharedInstance().latitute != 0 {
     
            
            if !Helper.networkReachable() {
                
                Helper.alertVC(title: ALERTS.Oops, message: ALERTS.NoNetwork)
                return
            }
            
            if !rxWeatherDetailsAPICall.weather_Details_Response.hasObservers {
                
                rxWeatherDetailsAPICall.weather_Details_Response
                    .subscribe(onNext: {response in
                        
                         completion(self.WebServiceResponse(response: response))
                        
                    }, onError: {error in
                        
                    }).disposed(by: disposebag)
                
            }
            
            rxWeatherDetailsAPICall.getWeatherForeCastDetailsFromLatAndLongServiceAPICall(latitude: LocationManager.sharedInstance().latitute, longitude: LocationManager.sharedInstance().longitude)
            
            
        }
    }
    
    
    /// Method to get Any city weather details using cityId
    ///
    /// - Parameters:
    ///   - cityId: cityId to get weather details
    ///   - completion:array Of Forecast details
    func getAnyCityWeatherDetails(cityId:Int32,
                                  completion:@escaping ([ForeCastModel]) -> ()) {
        
            if !Helper.networkReachable() {
                
                Helper.alertVC(title: ALERTS.Oops, message: ALERTS.NoNetwork)
                return
            }
            
            if !rxWeatherDetailsAPICall.weather_Details_Response.hasObservers {
                
                rxWeatherDetailsAPICall.weather_Details_Response
                    .subscribe(onNext: {response in
                        
                      completion(self.WebServiceResponse(response: response))
                        
                    }, onError: {error in
                        
                    }).disposed(by: disposebag)
                
            }
            
            rxWeatherDetailsAPICall.getWeatherForecastDetailsServiceAPICall(cityId: cityId)
            
            
    }
    
    //MARK - WebService Response -
    func WebServiceResponse(response:APIResponseModel) -> [ForeCastModel]
    {
        if response.httpStatusCode == 200 {
            
            arrayOfForeCastModel = []
            UserDefaults.standard.setValue(Date().timeIntervalSince1970,forKey:USER_DEFAULTS.SERVICE.ServiceCallTimeStamp)
            UserDefaults.standard.synchronize
            
            if let cityDetails = response.data["city"] as? [String:Any] {
                
                if let cityId = cityDetails["id"] as? Int32 {
                    
                    UserDefaults.standard.setValue(cityId,forKey:USER_DEFAULTS.LOCATION.CurrentCityId)
                    UserDefaults.standard.synchronize
                    
                    if let foreCastDetails = response.data["list"] as? [[String:Any]] {
                        
                        //Save Result in CoreData
                        CoreDataContextOperationsManager.sharedInstance.insertWeatherDetailsToDatabase(cityId: cityId, weatherDetails: foreCastDetails)
                        
                        return self.parseForeCastResponse(foreCastDetailsResponse: foreCastDetails)
                    }
                    
                }
            }
            
            return arrayOfForeCastModel
            
        } else {
            
            //Got some Error
            return []
        }
        
        
    }
    
    
    /// Method to parse the Forecast Response from server
    ///
    /// - Parameter foreCastDetailsResponse: forecast response from server
    /// - Returns: array Of Forecast details
    func parseForeCastResponse(foreCastDetailsResponse:[[String:Any]]) -> [ForeCastModel] {
        
        arrayOfForeCastModel = []
        var arrayOfTempDates = [String]()
        
        for eachForeCastDetail in foreCastDetailsResponse {
            
            if let dateValue = eachForeCastDetail["dt_txt"] as? String, let dateTimeStamp = eachForeCastDetail["dt"] as? TimeInterval {
                
                let stringDate = String(dateValue.split(separator: " ")[0])
                
                if !arrayOfTempDates.contains(stringDate) {
                    
                    let foreCastModel = ForeCastModel.init(foreCastDetails: eachForeCastDetail, dateTimeStamp:dateTimeStamp)
                    
                    arrayOfTempDates.append(stringDate)
                    arrayOfForeCastModel.append(foreCastModel)
                }
                
            }
            
        }
        
        return arrayOfForeCastModel
      
    }
    
}
