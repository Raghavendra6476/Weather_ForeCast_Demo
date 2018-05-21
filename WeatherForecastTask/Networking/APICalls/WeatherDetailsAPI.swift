//
//  WeatherDetailsAPI.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class WeatherDetailsAPI {
    
    let disposebag = DisposeBag()
    let weather_Details_Response = PublishSubject<APIResponseModel>()
    
    
    /// Method get Weather Forecast details From Server using CityId
    func getWeatherForecastDetailsServiceAPICall(cityId:Int32){
        
        Helper.showPI(_message: "Loading...")
        
        let strURL = API.BASE_URL + API.METHOD.ForeCastDetails + "?id=\(cityId)&APPID=\(API.WeatherAPIKey)"
        
        RxAlamofire
            .requestJSON(.get, strURL ,
                         parameters:nil,
                         encoding:JSONEncoding.default,
                         headers: nil)
            .subscribe(onNext: { (r, json) in
                
                print("API Response \(strURL)\nStatusCode:\(r.statusCode)\nResponse:\(json)")
                if  let dict  = json as? [String:Any]{
                    
                    let statCode:Int = r.statusCode
                    let responseModel = APIResponseModel.init(statusCode: statCode, dataResponse: dict)
                    self.weather_Details_Response.onNext(responseModel)
                    
                }
                
                Helper.hidePI()
                
            }, onError: {  (error) in
                
                Helper.hidePI()
                print("API Response \(strURL)\nError:\(error.localizedDescription)")
                Helper.alertVC(title: ALERTS.Error , message: error.localizedDescription)
                
            }).disposed(by: disposebag)
        
    }
    
    /// Method to get Weather Forecast details From Server using current location
    func getWeatherForeCastDetailsFromLatAndLongServiceAPICall(latitude:Double,
                                                               longitude:Double){
        
        let strURL = API.BASE_URL + API.METHOD.ForeCastDetails + "?lat=\(latitude)&lon=\(longitude)&APPID=\(API.WeatherAPIKey)"
        
        Helper.showPI(_message: "Loading...")
        
        RxAlamofire
            .requestJSON(.get, strURL ,
                         parameters:nil,
                         encoding:JSONEncoding.default,
                         headers: nil)
            .subscribe(onNext: { (r, json) in
                
                print("API Response \(strURL)\nStatusCode:\(r.statusCode)\nResponse:\(json)")
                if  let dict  = json as? [String:Any]{
                    
                    let statCode:Int = r.statusCode
                    let responseModel = APIResponseModel.init(statusCode: statCode, dataResponse: dict)
                    self.weather_Details_Response.onNext(responseModel)
                    
                }
                
                Helper.hidePI()
                
            }, onError: {  (error) in
                
                print("API Response \(strURL)\nError:\(error.localizedDescription)")
                Helper.alertVC(title: ALERTS.Error , message: error.localizedDescription)
                
                Helper.hidePI()
                
            }).disposed(by: disposebag)
        
    }


}
