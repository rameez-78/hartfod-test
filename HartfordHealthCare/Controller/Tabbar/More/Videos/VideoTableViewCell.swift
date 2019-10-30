//
//  VideoTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 28/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    public func populate(video: Video) {
        nameLabel.text = video.name
        thumbnail.image = UIImage(named: video.imageName)
    }
    
}
