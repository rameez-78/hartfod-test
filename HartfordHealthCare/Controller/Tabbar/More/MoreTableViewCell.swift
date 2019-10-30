//
//  MoreTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 28/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet weak var moreButton: UIButton! // It can be removed by replacing it with only label. Because through tableview did select method we can acheive navigation.
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
