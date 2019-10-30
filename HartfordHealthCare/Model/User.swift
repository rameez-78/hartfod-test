//
//  User.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var participantID: String = ""
    
    override static func primaryKey() -> String? {
        return "participantID"
    }
        
}
