//
//  MoreScreenButton.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 12/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

class MoreScreenButton {
    
    let title: MoreScreenButtonString
    var isCellRowAnimated: Bool = false
    
    init(title: MoreScreenButtonString) {
        self.title = title
    }
    
    static func getButtons() -> [MoreScreenButton] {
        
        let buttons = [
            MoreScreenButton(title: .benefitsOfMeditation),
            MoreScreenButton(title: .videos),
            MoreScreenButton(title: .reminders),
            MoreScreenButton(title: .meditationHistory),
            MoreScreenButton(title: .support),
            MoreScreenButton(title: .about)
        ]
        return buttons
        
    }
    
}

enum MoreScreenButtonString: String {
    case benefitsOfMeditation = "Benefits of Meditation"
    case videos = "Videos"
    case reminders = "Reminders"
    case meditationHistory = "Meditation History"
    case support = "Support"
    case about = "About"
}
