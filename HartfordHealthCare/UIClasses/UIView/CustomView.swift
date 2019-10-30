//
//  RoundedCornersView.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 5/7/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(layer.cornerRadius)
        } set {
            layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        } set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        } set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(layer.shadowRadius)
        } set {
            layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }

}
