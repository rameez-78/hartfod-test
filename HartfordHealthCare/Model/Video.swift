//
//  Video.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 28/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

class Video {
    
    let name: String
    let url: String
    let imageName: String
    var isCellRowAnimated: Bool = false
    
    init(name: String, url: String, imageName: String) {
        self.name = name
        self.url = url
        self.imageName = imageName
    }
    
    static func getVideos() -> [Video] {
        
        let videos: [Video] = [
            Video(
                name: "Radiofrequency Ablation",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Radiofrequency_Ablation.mp4",
                imageName: "RFThermalAblation"
            ),
            Video(
                name: "Treating Chronic Pain",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Treating_Chronic_Pain.mp4",
                imageName: "TreatingChronicPain"
            ),
            Video(
                name: "Spinal Cord Stimulator",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Spinal_Cord_Stimulator.mp4",
                imageName: "SpinalCordStimulator"
            ),
            Video(
                name: "Laser Therapy for Shingles Pain",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Laser_Therapy_For_Shingles_Pain.mp4",
                imageName: "LaserTherapyForShinglesPain"
            ),
            Video(
                name: "Laser Light Therapy for Pain",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Laser_Light_Therapy_For_Pain.mp4",
                imageName: "LaserLightTherapyForPain"
            ),
            Video(
                name: "Headache Pain Treatment Options Available to Patients",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Headache_Pain_Treatment_Options_Available_To_Patients.mp4",
                imageName: "HeadachePainTreatmentOptionsAvailableToPatients"
            ),
            Video(
                name: "Drug-free Pain Management",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Drug-free_Pain_Management.mp4",
                imageName: "Drug-freePainManagement"
            ),
            Video(
                name: "Non-medication and Pain-free Treatment for CIPN (Chemotherapy-Induced Peripheral Neuropathy)",
                url: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/HH_Videos/Non-Medication_and_Pain-Free_Treatment_for_CIPN.mp4",
                imageName: "Non-medicationandPain-freeTreatmentforCIPN"
            )]
        return videos
        
    }
    
}
