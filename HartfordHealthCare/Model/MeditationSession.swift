//
//  MeditationSession.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 21/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class MeditationSession: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var playDateTime: Date = Date()
    @objc dynamic var playDate: String = ""
    @objc dynamic var meditationName: String = ""
    @objc dynamic var completedPercentage: String = ""
    @objc dynamic var completedDuration: String = ""
    @objc dynamic var userParticipantID: String = ""
    var isCellRowAnimated: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func incrementID() -> Int {
        let sessions = DBManager.shared().getMeditationSessions()
        return (sessions.max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}
