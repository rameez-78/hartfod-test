//
//  DailyReminder.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

class DailyReminder: Codable {
    
    public var reminderID: Int = 0
    public var reminderDateTime: String = ""
    public var reminderTime: String = ""
    public var reminderMeridiem: String = ""
    public var isEnable: Bool = true
    
    
    public func incrementID() -> Int {
        
        guard let dailyReminders = UserDefaults.standard.getArray(object: DailyReminder.self, key: UserDefaultKeys.dailyReminders) else {
            return 1
        }
        guard let lastReminder = dailyReminders.last else {
            return 1
        }
        return lastReminder.reminderID + 1
        
    }
    
}
