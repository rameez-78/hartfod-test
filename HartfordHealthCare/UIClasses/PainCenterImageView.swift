//
//  PainCenterImageView.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 28/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class PainCenterImageView: UIImageView {

    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        layer.borderWidth = 2.0
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradienLayer = CAGradientLayer()
        gradienLayer.frame = frame
        gradienLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0.05).cgColor, UIColor.white.withAlphaComponent(0.1).cgColor, UIColor.white.withAlphaComponent(0.15).cgColor, UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.white.withAlphaComponent(0.7).cgColor]
        layer.addSublayer(gradienLayer)
    }
    
}
