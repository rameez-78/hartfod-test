//
//  Router.swift
//  Hartford Healthcare
//
//  Created by Rameez Raja on 01/08/2019.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct Router {
    
    
    // MARK: Shared Instance
    static let shared = Router()
    
    
    // MARK: Storyboards
    private var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "main", bundle: Bundle.main)
    }
    
    
    // MARK: Controller Initializer
    public func getController(identifier: String, storyboard: Storyboard) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        let controller = uiStoryboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    
    // MARK: Default Pusher
    public func pushViewController(with identifier: String, navigationController: UINavigationController?, storyboard: Storyboard) {
        
        guard let navController = navigationController else {
            return
        }
        let vc = getController(identifier: identifier, storyboard: storyboard)
        navController.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: Custom Pushers
    public func pushMediaPlayerViewController(navigationController: UINavigationController?, meditation: Meditation) {
        
        guard let navController = navigationController else {
            return
        }
        let vc = getController(identifier: MediaPlayerViewController.identifier, storyboard: .main) as! MediaPlayerViewController
        vc.currentMeditation = meditation
        navController.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: Default Pusher
    public func presentVC(on controller: UIViewController, identifier: String, storyboard: Storyboard, animated: Bool) {
        let vc = getController(identifier: identifier, storyboard: storyboard)
        controller.present(vc, animated: animated, completion: nil)
    }

    
    // MARK: Set Root VC
    public func setTabbarAsRootVC() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let window = appDelegate.window else {
            return
        }
        
        let tabbarVC = getController(identifier: MainTabBarViewController.identifier, storyboard: .main) as! MainTabBarViewController
        let homeVC = UINavigationController(rootViewController: getController(identifier: HomeViewController.identifier, storyboard: .main))
        let contactsVC = UINavigationController(rootViewController: getController(identifier: ContactsViewController.identifier, storyboard: .main))
        let moreVC = UINavigationController(rootViewController: getController(identifier: MoreViewController.identifier, storyboard: .main))
        tabbarVC.viewControllers = [homeVC, contactsVC, moreVC]
        
        let tabbar = tabbarVC.tabBar
        tabbar.barTintColor = Colors.tabbarTintColor
        tabbar.backgroundColor = Colors.tabbarTintColor
        tabbar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        let tabHome = tabbar.items![0]
        tabHome.title = "Home" // tabbar titlee
        tabHome.image = UIImage(named: "home-tabbar")
        tabHome.selectedImage = UIImage(named: "home-tabbar")
        
        let tabContacts = tabbar.items![1]
        tabContacts.title = "Contacts"
        tabContacts.image = UIImage(named: "contacts-tabbar")
        tabContacts.selectedImage = UIImage(named: "contacts-tabbar")
        
        let tabMore = tabbar.items![2]
        tabMore.title = "More"
        tabMore.image = UIImage(named: "more-tabbar")
        tabMore.selectedImage = UIImage(named: "more-tabbar")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        window.rootViewController = tabbarVC
        window.makeKeyAndVisible()
        UserDefaults.standard.setValue(OnBoardingScreen.none.rawValue, forKey: UserDefaultKeys.onBoardingProcessScreen)
        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isOnBoardingCompleted)

    }
    
    public func setOnBoardingProcessAsRootVC(onBoardingScreen: OnBoardingScreen) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let window = appDelegate.window else {
            return
        }
        
        var rootVC: UIViewController!
        switch onBoardingScreen {
        case .none:
            rootVC = getController(identifier: LoginViewController.identifier, storyboard: .authentication)
        case .reminderTimeSelection:
            rootVC = getController(identifier: ReminderTimeSelectionViewController.identifier, storyboard: .authentication)
        case .remindersListing:
            rootVC = getController(identifier: RemindersViewController.identifier, storyboard: .main)
        case .introductoryMeditation:
            rootVC = getController(identifier: IntroductoryMediationViewController.identifier, storyboard: .authentication)
        }
        let navController = UINavigationController(rootViewController: rootVC)
        navController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
    }
    
    public func logOutAndSetAuthAsRootVC() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let window = appDelegate.window else {
            return
        }
        
        SyncUser.current?.logOut()
        let controller = getController(identifier: LoginViewController.identifier, storyboard: .authentication)
        let navController = UINavigationController(rootViewController: controller)
        navController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
    }

    
}

enum Storyboard: String {
    case authentication = "Authentication"
    case main = "Main"
}
