//
//  UITextField+Extension.swift
//  Cloud9
//
//  Created by Rameez Raja on 06/08/2019.
//  Copyright © 2019 Rameez Raja. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func addLeftViewWithIcon(icon: UIView) {

        icon.backgroundColor = UIColor.clear
        let leftViewToAdd = UIView(frame: CGRect(x: 0, y: 0, width: icon.frame.width + 10, height: frame.height))
        leftViewToAdd.backgroundColor = UIColor.clear
        leftViewToAdd.addSubview(icon)
        leftView = leftViewToAdd
        leftViewMode = .always
        
    }
    
}
