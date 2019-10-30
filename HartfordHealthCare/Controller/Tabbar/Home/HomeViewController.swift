//
//  Tab1ViewController.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 3/4/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
import AVFoundation
import XLPagerTabStrip

class HomeViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var meditationListingView: UIView!
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        setupMeditationsViewController()
        subscribeForRealmSyncing()
        
    }
    
    private func setupMeditationsViewController() {
        
        let meditationsVC = Router.shared.getController(identifier: MeditationsViewController.identifier, storyboard: .main) as! MeditationsViewController
        
        let painMeditationVC = Router.shared.getController(identifier: MeditationListingViewController.identifier, storyboard: .main) as! MeditationListingViewController
        let painMeditationIndicatorInfo = IndicatorInfo(title: "For Pain")
        painMeditationVC.indicatorInfo = painMeditationIndicatorInfo
        painMeditationVC.meditations += Meditation.getPainMeditations()
        
        let lifeMeditationVC = Router.shared.getController(identifier: MeditationListingViewController.identifier, storyboard: .main) as! MeditationListingViewController
        let lifeMeditationIndicatorInfo = IndicatorInfo(title: "For Quality of Life")
        lifeMeditationVC.indicatorInfo = lifeMeditationIndicatorInfo
        lifeMeditationVC.meditations += Meditation.getQualityForLifeMeditations()
        
        meditationsVC.listingViewControllers.append(painMeditationVC)
        meditationsVC.listingViewControllers.append(lifeMeditationVC)
        
        addChild(meditationsVC)
        meditationsVC.view.frame = meditationListingView.bounds
        meditationListingView.addSubview(meditationsVC.view)
        meditationsVC.didMove(toParent: self)
        
    }
    
    private func subscribeForRealmSyncing() {

        DBManager.shared().subscribeForAllObjects { (error) in
            if error != nil {
                self.showBasicAlert(title: Strings.error, message: Strings.unExpectedResultWhileSyncing)
            }
        }
        
    }
    
}
