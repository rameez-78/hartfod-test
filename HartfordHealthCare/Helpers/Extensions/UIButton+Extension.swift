//
//  UIButton+Extension.swift
//  Cloud9
//
//  Created by Rameez Raja on 06/08/2019.
//  Copyright © 2019 Rameez Raja. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    func setUnderlineAttribute(foregroundColor: UIColor, fontSize: CGFloat) {
        
        guard let buttonTitle = title(for: .normal) else {
            return
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: foregroundColor, NSAttributedString.Key.font: fontSize, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSMutableAttributedString(string: buttonTitle, attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)
        
    }
    
}
