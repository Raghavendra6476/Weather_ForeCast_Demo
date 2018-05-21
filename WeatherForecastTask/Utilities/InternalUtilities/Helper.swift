//
//  Helper.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import UIKit
import Alamofire

class Helper: NSObject,NVActivityIndicatorViewable {
    
    // MARK: - Variable Deceleration -
    static var cities = [[String:Any]]()
    
    
    ///Method to Show Progress Indicator with Message
    ///
    /// - Parameter _message: message string to show in progress
    class func showPI(_message:  String) {
        
        let activityData = ActivityData(size: CGSize(width: 30,height: 30),
                                        message: _message,
                                        
                                        type: NVActivityIndicatorType(rawValue: 29),
                                        color: UIColor.white,
                                        padding: nil,
                                        displayTimeThreshold: nil,
                                        minimumDisplayTime: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let when = DispatchTime.now() + 90
        DispatchQueue.main.asyncAfter(deadline: when){
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    /// Hide Progress Indicator
    class func hidePI() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    
    /// Method to show alert View controller
    ///
    /// - Parameters:
    ///   - title: alertVC title string
    ///   - message: alertVC message string
    class func alertVC(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let newAlertWindow = UIWindow(frame: UIScreen.main.bounds)
        newAlertWindow.rootViewController = UIViewController()
        newAlertWindow.windowLevel = UIWindowLevelAlert + 1
        newAlertWindow.makeKeyAndVisible()
        
        // Create the actions
        let okAction = UIAlertAction(title: ALERTS.Ok, style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            newAlertWindow.resignKey()
            newAlertWindow.removeFromSuperview()
        }
        // Add the actions
        alertController.addAction(okAction)
        
        newAlertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    
    /// Method to Read data from jason File
    class func getCityDetailsFormJsonSerial() {
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cityList", ofType: "json")!))
        
        do {
            
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            cities = parsedObject as! [[String : Any]]
            
        }catch{
            
            print("not able to parse")
        }
        
    }
    
    
    /// Method to get cityId from city Name
    ///
    /// - Parameter cityName: input cityName value
    /// - Returns: cityId value
    class func getCityIdByCityName(cityName:String) -> Int {
        
        if let cityIndex = cities.index(where: {($0["name"] as? String) == cityName}) {
            
            if let cityId = cities[cityIndex]["id"] as? Int {
                
                return cityId
            }
        }
        
        return 0
    }
    
    /// Method to get cityName from cityId
    ///
    /// - Parameter cityId: input cityId value
    /// - Returns: cityName value
    class func getCityNameByCityId(cityId:Int32) -> String {
        
        if let cityIndex = cities.index(where: {($0["id"] as? Int32) == cityId}) {
            
            if let cityName = cities[cityIndex]["name"] as? String {
                
                return cityName
            }
        }
        
        return ""
    }
    
    
    
    /// Method to check currently Network is Reachable
    ///
    /// - Returns: network reachable status True or False
    class func networkReachable() -> Bool {
        
        return (NetworkReachabilityManager()?.isReachable)!
    }
    
    
    /// Method to Read Configuration value from file
    ///
    /// - Parameters:
    ///   - key: key value
    ///   - file: file name
    ///   - type: type of file
    /// - Returns: value from the key in file
    class func readConfigurationValue(_ key: String ,file: String, type: String) -> String! {
        
        if let path = Bundle.main.path(forResource: file, ofType: type) {
            
            let dictionary = NSDictionary(contentsOfFile: path)
            return dictionary?.value(forKey: key) as! String
            
        } else {
            
            return nil
        }
    }
    
    
    /// Method to maintain weather details showing in Weather details VC
    ///
    /// - Parameters:
    ///   - value: weather detail Value
    ///   - extensionValue: weather detail externsion
    /// - Returns: weather detail Value with extension
    class func getValueByItsExtension(value:Double,extensionValue:String) -> String {
        
         return String(format:"%.1f %@", value, extensionValue)
    }

}
