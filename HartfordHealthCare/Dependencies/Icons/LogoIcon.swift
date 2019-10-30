//
//  LogoIcon.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 16/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class LogoIcon: UIView {
    
    override func draw(_ rect: CGRect) {
        HHStyleKit.drawLogo(frame: bounds, resizing: .aspectFit)
        setNeedsDisplay()
    }
    
}
