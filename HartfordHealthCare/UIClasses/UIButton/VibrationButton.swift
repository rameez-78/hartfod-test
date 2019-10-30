//
//  VibrationButton.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 8/10/18.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
import AVKit

class VibrationButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AudioServicesPlaySystemSound(1519)
    }

}
