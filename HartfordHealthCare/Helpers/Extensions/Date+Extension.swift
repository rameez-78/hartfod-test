//
//  Date+Extension.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 23/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

extension Date {
    
    func getDateStringForSession() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dMMMyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }

    func getDateStringForMeditationHistoryFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }

    func getDateTimeToStoreInToDB() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
    
}
