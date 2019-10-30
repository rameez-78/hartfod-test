//
//  Device.swift
//  Hartford Healthcare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds.size

struct Device {
    
    static func isIPhone5() -> Bool {
        
        if screenSize.width == 320 && screenSize.height == 568 {
            return true
        }
        return false
        
    }

    static func isIPhone6() -> Bool {
        
        if screenSize.width == 375 && screenSize.height == 667 {
            return true
        }
        return false
        
    }

    static func isIPhone8Plus() -> Bool {
        
        if screenSize.width == 414 && screenSize.height == 736 {
            return true
        }
        return false
        
    }

    static func isIPhoneXAndGreater() -> Bool {
        
        if screenSize.height > 800 {
            return true
        }
        return false
        
    }
    
    static func isSmalliPad() -> Bool {
        
        if screenSize.width == 768 && screenSize.height == 1024 {
            return true
        }
        return false
        
    }

    static func isMediumiPad() -> Bool {
        
        if screenSize.width == 834 && screenSize.height == 1112 {
            return true
        }
        return false
        
    }

    static func isMediumi2Pad() -> Bool {
        
        if screenSize.width == 834 && screenSize.height == 1194 {
            return true
        }
        return false
        
    }

    static func isLargeiPad() -> Bool {
        
        if screenSize.width == 1024 && screenSize.height == 1366 {
            return true
        }
        return false
        
    }
    
}
