//
//  MediaPlayerSlider.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 29/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MediaPlayerSlider: UISlider {

    @IBInspectable open var barHeight:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: (defaultBounds.origin.y) + (defaultBounds.size.height / 2) - (barHeight / 2),
            width: defaultBounds.size.width,
            height: barHeight
        )
    }
    
}
