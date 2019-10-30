//
//  BlueSquareCentre.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 06/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class BlueSquareCentre: UIView {

    override func draw(_ rect: CGRect) {
        HHStyleKit.drawStoreIconBlue(frame: bounds, resizing: .aspectFit)
        setNeedsDisplay()
    }
    
}
