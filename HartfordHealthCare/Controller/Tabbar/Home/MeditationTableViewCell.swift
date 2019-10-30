//
//  MeditationTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 07/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MeditationTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var meditationIconView: UIView!
    @IBOutlet weak var meditationTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12.0
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        bgView.layer.borderWidth = 1.0
    }
    
    
    public func populate(meditation: Meditation) {
        
        meditationTitleLabel.text = meditation.name
        meditation.iconView.frame = meditationIconView.bounds
        meditation.iconView.backgroundColor = UIColor.clear
        meditationIconView.addSubview(meditation.iconView)
        
    }

}
