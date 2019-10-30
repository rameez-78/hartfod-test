//
//  BackPainIcon.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 23/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class BackPainIcon: UIView {

    override func draw(_ rect: CGRect) {
        HHStyleKit.drawBackPainIcon(frame: bounds, resizing: .aspectFit)
        setNeedsDisplay()
    }
    
}
