//
//  Doctor.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 27/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

class Doctor {
    
    let name: String
    let phoneNumber: String
    let imageName: String
    var isCellRowAnimated: Bool = false
    
    init(name: String, phoneNumber: String, imageName: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.imageName = imageName
    }
    
    static func getDoctors() -> [Doctor] {
        
        let doctors: [Doctor] = [
            Doctor(name: "Michael J. Grille, MD", phoneNumber: "860.696.2840", imageName: "MichaelJ.Grille,MD"),
            Doctor(name: "Anton Robert Cherry, PA-C", phoneNumber: "860.696.2840", imageName: "AntonRobertCherry,PA-C"),
            Doctor(name: "Kimberly J. Tschetter, PA-C", phoneNumber: "860.696.2840", imageName: "KimberlyJ.Tschetter,PA-C"),
            Doctor(name: "Jonathan Anthony Kost, MD", phoneNumber: "860.696.2840", imageName: "JonathanAnthonyKost,MD"),
            Doctor(name: "Ricardo J. Taboada, MD", phoneNumber: "860.696.2840", imageName: "RicardoJ.Taboada,MD"),
            Doctor(name: "Susan I. Erwin, APRN", phoneNumber: "860.696.2840", imageName: "SusanI.Erwin,APRN"),
            Doctor(name: "Andreo Dana, APRN", phoneNumber: "860.696.2843", imageName: "AndreoDana,APRN"),
            Doctor(name: "Krista W. Maloney, APRN", phoneNumber: "", imageName: "KristaW.Maloney,APRN"),
            Doctor(name: "Susan M. Woodson, PA-C", phoneNumber: "860.972.0197", imageName: "SusanM.Woodson,PA-C")]
        return doctors
        
    }
}
