//
//  MediaPlayerControlsBackground.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 21/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MediaPlayerControlsBackground: UIView {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        let circlePath = UIBezierPath(ovalIn: CGRect(x: -50, y: 0, width: bounds.width + 100, height: bounds.height + 100))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        layer.mask = shapeLayer
    }
    
}
