//
//  ReminderTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var enableDisableSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func populate(dailyReminder: DailyReminder) {
        
        timeLabel.text = dailyReminder.reminderTime
        meridiemLabel.text = dailyReminder.reminderMeridiem
        if dailyReminder.isEnable {
            enableDisableSwitch.setOn(true, animated: true)
        } else {
            enableDisableSwitch.setOn(false, animated: false)
        }
        
    }
    
}
