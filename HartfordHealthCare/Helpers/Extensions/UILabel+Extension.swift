//
//  MultiLineLabel.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 7/20/18.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    //MARK: This gets the height that the label should be to fit all text comfortably
    var optimalHeight: CGFloat {
        get{
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)))
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
}
