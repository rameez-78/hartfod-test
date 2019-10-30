//
//  ReminderTimeSelectionViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class ReminderTimeSelectionViewController: UIViewController {
    
    
    // MARK: Outlets
    
    
    // MARK: Properties
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Action
    @IBAction func chooseTimeButtonTapped(_ sender: Any) {
        Router.shared.pushViewController(with: RemindersViewController.identifier, navigationController: navigationController, storyboard: .main)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        Router.shared.setTabbarAsRootVC()
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        UserDefaults.standard.setValue(OnBoardingScreen.reminderTimeSelection.rawValue, forKey: UserDefaultKeys.onBoardingProcessScreen)

    }
    
}
