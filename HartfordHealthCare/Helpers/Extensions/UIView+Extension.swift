//
//  UIView+Extension.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 23/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addAppThemeGradient() {
        
        let colors: [UIColor] = [UIColor.white, UIColor.white, HHStyleKit.splashGradientColor]
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        layer.insertSublayer(gradient, at: 0)
        
    }
    
    public var isActivityViewVisible: Bool {
        if viewWithTag(Constants.fadeOutBGTag) != nil {
            return true
        } else {
            return false
        }
    }
    
    func showSpinner(isUserInteractionEnabled: Bool, isForMediaPlayer: Bool) { // As media player controls are not in center of screen, that's why while loading the spinner position doesn't feel centerlized. That's why we put a flag here.
        
        DispatchQueue.main.async {
            
            let bgViewFrame: CGRect
            let activityViewFrame: CGRect
            if isForMediaPlayer {
                bgViewFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
                activityViewFrame = CGRect(x: 10, y: 10, width: 40, height: 40)
            } else {
                bgViewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
                activityViewFrame = CGRect(x: 10, y: 10, width: 80, height: 80)
            }
            let bgView = UIView(frame: bgViewFrame)
            bgView.layer.cornerRadius = 12.0
            if isForMediaPlayer {
                bgView.center = CGPoint(x: self.center.x - 8.0, y: self.frame.height - 80.0)
            } else {
                bgView.center = self.center
            }
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            bgView.clipsToBounds = true
            bgView.tag = Constants.fadeOutBGTag
            self.addSubview(bgView)
            
            let activityView = UIActivityIndicatorView(frame: activityViewFrame)
            activityView.style = .whiteLarge
            activityView.tag = Constants.activityViewTag
            activityView.startAnimating()
            bgView.addSubview(activityView)
            
            if isUserInteractionEnabled == false {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            
        }
        
    }
    
    func removeSpinner() {
        
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
            if let activityView = self.viewWithTag(Constants.fadeOutBGTag) {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    activityView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }, completion: { success in
                    activityView.removeFromSuperview()
                })
            }
        }
        
    }

}
