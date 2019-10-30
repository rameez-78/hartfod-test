//
//  MidstateCentre.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 06/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MidstateCentre: UIView {

    override func draw(_ rect: CGRect) {
        HHStyleKit.drawStoreIconOrange(frame: bounds, resizing: .aspectFit)
        setNeedsDisplay()
    }
    
}
