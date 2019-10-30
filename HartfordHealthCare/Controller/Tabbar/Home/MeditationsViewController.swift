//
//  MeditationsViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MeditationsViewController: ButtonBarPagerTabStripViewController {
    
    
    // MARK: Properties
    public var listingViewControllers: [UIViewController] = []
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        buttonBarView.selectedBar.backgroundColor = Colors.tabbarTintColor
        buttonBarView.backgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.black
        settings.style.selectedBarHeight = 1
//        settings.style.buttonBarHeight = 100

    }
    
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return listingViewControllers
    }
    
    
}
