//
//  LinkSession.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 26/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import RealmSwift

class LinkSession: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var clickTime: String = ""
    @objc dynamic var clickName: String = ""
    @objc dynamic var userParticipantID: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func incrementID() -> Int {
        let sessions = DBManager.shared().getLinkSessions()
        return (sessions.max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}
