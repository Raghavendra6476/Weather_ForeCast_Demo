//
//  LocationEnableView.swift
//  
//
//  Created by Vasant Hugar on 02/01/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit

class LocationEnableView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationDisabled: UILabel!
    @IBOutlet weak var locationMessage: UILabel!
    @IBOutlet weak var locationEnabled: UILabel!
    @IBOutlet weak var enableLocation: UIButton!
    
    private static var obj: LocationEnableView? = nil
    
    
    
    /// Get Shared Instance
    ///
    /// - Returns: Popup Object
    static var shared: LocationEnableView {
        
        if obj == nil {
            
            obj = Bundle(for: self).loadNibNamed("LocationEnableView",
                                                 owner: nil,
                                                 options: nil)?.first as? LocationEnableView
        }
        return obj!
    }
    
    
    /// Method to show location not enabled view
    func show() {
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        
        self.frame = window.frame
        window.addSubview(self)
        
        self.layoutIfNeeded()
        
        showAnimate()
    }
    
    
    
    /// Method to hide location not enabled view
    func hide() {
        hideAnimate()
    }
    
    
    
    /// Method to open app settings page to enable location
    ///
    /// - Parameter sender: button properties
    @IBAction func enableLocationButton(_ sender: AnyObject) {
        
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!,
                                  options: [:]) { (result) in
            
        }
        
    }
    
    
    //MARK: - Animation
    
    /// Show Popup Animation
    private func showAnimate() {
        
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.alpha = 0.0;
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.alpha = 1.0
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    /// Hide Popup Animation
    private func hideAnimate() {
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        self.alpha = 0.0;
        },
                       completion:{(finished : Bool)  in
                        self.removeFromSuperview()
                        LocationEnableView.obj = nil
        });
    }
}
