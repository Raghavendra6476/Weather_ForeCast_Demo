//
//  LocationManager.swift


import UIKit
import CoreLocation

@objc protocol LocationManagerDelegate {
    
    /// When Update Location
    @objc optional func didChangedCurrentCity(location: LocationManager)
    
    /// When Failed to Update Location
    @objc optional func didFailToUpdateLocation()
    
    /// Did Change Authorized
    ///
    /// - Parameter authorized: YES or NO
    @objc optional func didChangeAuthorization(authorized: Bool)
}

class LocationManager: NSObject {
    
    var latitute = 0.0
    var longitude = 0.0
    
    var locationObj: CLLocationManager? = nil
    var delegate: LocationManagerDelegate? = nil
    
    var userDefaults = UserDefaults.standard
    
    static var obj:LocationManager? = nil
    
    class func sharedInstance() -> LocationManager {
        
        if obj == nil {
            
            obj = LocationManager()
        }
        
        
        obj?.latitute = UserDefaultsManager.prevLatitude
        obj?.longitude = UserDefaultsManager.prevLongitude
        
        return obj!
    }

    
    override init() {
        
        super.init()
        locationObj = CLLocationManager()
        locationObj?.delegate = self
        locationObj?.requestWhenInUseAuthorization()
        
    }
    /// Start Location Update
    func start() {
        locationObj?.startUpdatingLocation()
    }
    /// Stop Location Update
    func stop() {
        locationObj?.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch(status) {
            
            case .notDetermined:
                
//                delegate?.didChangeAuthorization!(authorized: false)
                
                break
                
            case .restricted, .denied:
                
                print("No access")
                
                let view = LocationEnableView.shared
                view.show()
                
//                delegate?.didChangeAuthorization!(authorized: false)
                
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                print("Access")
                
                locationObj?.startUpdatingLocation()
                
                let view = LocationEnableView.shared
                view.hide()
                
//                delegate?.didChangeAuthorization!(authorized: true)
                
                break
        }
    }
    
    
    
    /// CLLocation manager delegate method for successfuly fetched location details
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager object
    ///   - locations: location details
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            
            stop()
            
            let location = locations.first
            
            var needToCallService = false
            
            if latitute == 0.0 {
                
                needToCallService = true
            }
            
            latitute = (location?.coordinate.latitude)!
            longitude = (location?.coordinate.longitude)!
            
            userDefaults.set(latitute, forKey: USER_DEFAULTS.LOCATION.Latitude)
            userDefaults.set(longitude, forKey: USER_DEFAULTS.LOCATION.Longitude)
            userDefaults.synchronize()
            
            if needToCallService {
                
                self.delegate?.didChangedCurrentCity!(location: self)
            }
            
        }
    }
    
    
    
    /// CLLocation manager delegate method for error to fetch location details from CLLocation
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager object
    ///   - error: error details
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("\nDid fail location :\(error.localizedDescription)")
//        delegate?.didFailToUpdateLocation!()
    }
}
