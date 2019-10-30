//
//  MeditationHistoryTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 26/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MeditationHistoryTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playDateLabel: UILabel!
    @IBOutlet weak var completedDurationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    // MARK: Custom Methods
    public func populate(meditationSession: MeditationSession) {
        
        nameLabel.text = meditationSession.meditationName
        playDateLabel.text = meditationSession.playDateTime.getDateStringForMeditationHistoryFormat()
        if meditationSession.completedDuration == "1" {
            completedDurationLabel.text = "\(meditationSession.completedDuration) Minute Completed"
        } else {
            completedDurationLabel.text = "\(meditationSession.completedDuration) Minutes Completed"
        }
        
    }
    
}
