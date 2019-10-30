//
//  AppDelegate.swift
//  Cloud9
//
//  Created by Bradley Pickard on 4/18/18.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        // Local Notifications
        setupLocalNotifications()
        
        
        // App Center
        MSAppCenter.start("47572035-8767-4919-bd60-8ee0c9829a79", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        // Setup Root View Controller
        if UserDefaults.standard.value(forKey: UserDefaultKeys.isOnBoardingCompleted) != nil {
            Router.shared.setTabbarAsRootVC()
        } else {
            let onBoardingScreen = OnBoardingScreen(rawValue: (UserDefaults.standard.value(forKey: UserDefaultKeys.onBoardingProcessScreen) as? Int) ?? 0)!
            Router.shared.setOnBoardingProcessAsRootVC(onBoardingScreen: onBoardingScreen)
        }
        
        return true
        
    }
        
    func setupLocalNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in }
    }
    
}


// MARK: UNUserNotificationCenter Delegates
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

