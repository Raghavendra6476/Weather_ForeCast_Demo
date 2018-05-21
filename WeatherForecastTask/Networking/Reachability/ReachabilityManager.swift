//
//  ReachabilityManager.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 20/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import Foundation

class ReachabilityManager {
    
    static let sharedInstance = ReachabilityManager()
    
    func maintainNetworkReachability() {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    
    //MARK: - Network Reachable Status Method -
    
    /// Network status changed delegate method
    ///
    /// - Parameter notification: Network status changed notification details
    @objc func networkStatusChanged(_ notification: Notification) {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            ReachabilityView.instance.show()
            print("Network is not reachable")
            
        case .online(.wwan):
            ReachabilityView.instance.hide()
            
            print("Network is rechable now")
            
        case .online(.wiFi):
            ReachabilityView.instance.hide()
           
            print("Network is rechable now")
        }
        
    }
}
