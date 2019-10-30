//
//  UIImage+Extension.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 06/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func squared() -> UIImage {
        
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        let imageRef = self.cgImage?.cropping(to: cropSquare)
        
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: self.imageOrientation)
        
    }
    
}
