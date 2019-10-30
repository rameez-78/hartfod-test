//
//  Meditation.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 6/2/18.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit

class Meditation {
    
    let name: String
    let iconView: UIView
    let iconColor: UIColor
    let meditationImageName: String
    let meditationURL: String
    var isCellRowAnimated: Bool = false
    
    init(name: String, iconView: UIView, iconColor: UIColor, meditationURL: String, meditationImageName: String) {
        self.name = name
        self.iconView = iconView
        self.iconColor = iconColor
        self.meditationURL = meditationURL
        self.meditationImageName = meditationImageName
    }
    
    static func getPainMeditations() -> [Meditation] {
        
        let meditations: [Meditation] = [
            Meditation(
                name: "Relieving Back Pain",
                iconView: BackPainIcon(),
                iconColor: HHStyleKit.darkGreenColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1902_Back+Pain.mp3",
                meditationImageName: "BackPainIcon"
            ),
            Meditation(
                name: "Soothing Neck Pain",
                iconView: NeckPainIcon(),
                iconColor: HHStyleKit.lightBlueColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1903_Neck+Pain.mp3",
                meditationImageName: "NeckPainIcon"
            ),
            Meditation(
                name: "Easing Nerve Associated Pain",
                iconView: NeuropathicPainIcon(),
                iconColor: HHStyleKit.orangeColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1904_+Neuropathic+Pain.mp3",
                meditationImageName: "NeuropathicPainIcon"
            ),
            Meditation(
                name: "Relieving Migraine & Headache",
                iconView: HeadachesIcon(),
                iconColor: HHStyleKit.purpleColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1905_Headache_MIX.mp3",
                meditationImageName: "HeadachesIcon"
            )
        ]
        return meditations
        
    }
    
    static func getQualityForLifeMeditations() -> [Meditation] {
        
        let meditations: [Meditation] = [
            Meditation(
                name: "Boosting Your Energy Levels",
                iconView: FatigueIcon(),
                iconColor: HHStyleKit.orangeColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1906_Fatigue_MIX_rev1.mp3",
                meditationImageName: "FatigueIcon"
            ),
            Meditation(
                name: "Promoting a Restful Sleep",
                iconView: SleepIcon(),
                iconColor: HHStyleKit.lightBlueColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1901_Restful+Sleep_Mix_Rev1.mp3",
                meditationImageName: "SleepIcon"
            ),
            Meditation(
                name: "Alleviating Anxiety",
                iconView: AnxietyIcon(),
                iconColor: HHStyleKit.darkGreenColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1908_Anxiety_MIX.mp3",
                meditationImageName: "AnxietyIcon"
            ),
            Meditation(
                name: "Alleviating Depression",
                iconView: DepressionIcon(),
                iconColor: HHStyleKit.purpleColor,
                meditationURL: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1909_Depression.mp3",
                meditationImageName: "DepressionIcon"
            )
        ]
        return meditations
        
    }
    
}
