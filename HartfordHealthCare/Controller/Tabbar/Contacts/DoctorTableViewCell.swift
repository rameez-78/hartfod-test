//
//  DoctorTableViewCell.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 27/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var doctorImageView: UIImageView!

    
    // MARK: Initializer
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorImageView.layer.cornerRadius = 8.0
        doctorImageView.layer.borderColor = UIColor.black.cgColor
        doctorImageView.layer.borderWidth = 1.0
    }

    
    // MARK: Custom Methods
    public func populate(doctor: Doctor) {
        
        nameLabel.text = doctor.name
        doctorImageView.image = UIImage(named: doctor.imageName)
        if doctor.phoneNumber != "" {
            phoneNumberButton.setTitle(doctor.phoneNumber, for: .normal)
        } else {
            phoneNumberButton.setTitle("", for: .normal)
        }
        
    }
    
}
