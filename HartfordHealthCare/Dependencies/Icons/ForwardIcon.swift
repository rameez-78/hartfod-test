//
//  ForwardIcon.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 29/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class ForwardIcon: UIView {

    override func draw(_ rect: CGRect) {
        HHStyleKit.drawForwardArrow(frame: bounds, resizing: .aspectFit)
        setNeedsDisplay()
    }

}
