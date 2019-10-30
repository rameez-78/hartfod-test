//
//  NSObject+Extension.swift
//  Hartford Healthcare
//
//  Created by Rameez Raja on 01/08/2019.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    class var identifier: String {
        return String(describing: self)
    }
    
}
