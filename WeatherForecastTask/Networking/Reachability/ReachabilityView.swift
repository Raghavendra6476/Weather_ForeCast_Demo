 //
//  ReachabilityShowView.swift


import UIKit

class ReachabilityView: UIView {
    
    private static var share: ReachabilityView? = nil
    var isShown:Bool = false
    
    static var instance: ReachabilityView {
        
        if (share == nil) {
            if let views = Bundle(for: self).loadNibNamed("ReachabilityView", owner: nil, options: nil) {
                share = views.first as? ReachabilityView
            }
        }
        return share!
    }
    
    /// Show Network
    func show()
    {
        if isShown == false {
            
            if let window = UIApplication.shared.keyWindow {
                isShown = true
                self.frame = (window.frame)
                window.addSubview(self)
                
                self.alpha = 0.0
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.alpha = 1.0
                })
            }
        }
    }
    
    /// Hide
    func hide() {
        if isShown == true {
            isShown = false
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.alpha = 0.0
            },
                           completion: { (completion) in
                            
                        self.removeFromSuperview()
                            
            })
        }
    }
}
