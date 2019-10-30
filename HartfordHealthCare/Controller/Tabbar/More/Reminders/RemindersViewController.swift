//
//  RemindersViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class RemindersViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    private var reminders: [DailyReminder] = []
    private var reminderTimeVC: ReminderTimeViewController!
    private let totalHeight: CGFloat = 260.0
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: Action
    @IBAction func addReminderButtonTapped(_ sender: Any) {
        
        if reminders.count == 3 {
            showBasicAlert(title: Strings.error, message: Strings.dailyRemindersLimitExceeded)
        } else {
            showReminderTimeVC(reminderForEdit: nil)
        }
        
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        checkForNotificationPermissions()
        setupForOnboarding()
        populateDataSource()
        
    }
    
    private func checkForNotificationPermissions() {

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                self.showAlertForSettings(message: Strings.remoteNotificationsAreNotEnabled)
            }
        }
        
    }
    
    private func setupForOnboarding() {

        if UserDefaults.standard.value(forKey: UserDefaultKeys.isOnBoardingCompleted) == nil {
            UserDefaults.standard.setValue(OnBoardingScreen.remindersListing.rawValue, forKey: UserDefaultKeys.onBoardingProcessScreen)
            setupDoneButton()
            showReminderTimeVC(reminderForEdit: nil)
        }

    }
    
    private func populateDataSource() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        guard let dailyReminders = UserDefaults.standard.getArray(object: DailyReminder.self, key: UserDefaultKeys.dailyReminders) else {
            return
        }
        reminders += dailyReminders
        
    }
    
    private func setupDoneButton() {

        let doneButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarButtonItemTapped(sender:)))
        navigationItem.leftBarButtonItem = doneButtonItem

    }
    
    @objc private func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        Router.shared.setTabbarAsRootVC()
    }
    
    @objc private func reminderEnableSwitchUpdate(sender: UISwitch) {
    
        let reminder = reminders[sender.tag]
        reminder.isEnable = sender.isOn
        if reminder.isEnable {
            scheduleDailyReminderNotification(reminderDate: reminder.reminderDateTime.convertToDate(), notificationIdentifier: reminder.reminderID)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(reminder.reminderID)"])
        }
        UserDefaults.standard.setArray(objects: reminders, key: UserDefaultKeys.dailyReminders)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
        
    }
    
    private func showReminderTimeVC(reminderForEdit: DailyReminder?) {
        
        DispatchQueue.main.async {
            
            var topSpace:CGFloat
            var bottomSpace:CGFloat
            if #available(iOS 11.0, *) {
                topSpace = self.view.safeAreaInsets.top
                bottomSpace = self.view.safeAreaInsets.bottom
            } else {
                topSpace = self.topLayoutGuide.length
                bottomSpace = self.bottomLayoutGuide.length
            }
            
            if self.reminderTimeVC == nil {
                self.reminderTimeVC = (Router.shared.getController(identifier: ReminderTimeViewController.identifier, storyboard: .main) as! ReminderTimeViewController)
                self.reminderTimeVC.delegate = self
                self.addChild(self.reminderTimeVC)
                self.reminderTimeVC.view.frame = CGRect(x: 0, y: self.view.frame.height + topSpace, width: self.view.frame.width, height: self.totalHeight)
                self.view.addSubview(self.reminderTimeVC.view)
                self.reminderTimeVC.didMove(toParent: self)
            }
            if reminderForEdit != nil {
                self.reminderTimeVC.reminderForEdit = reminderForEdit
                self.reminderTimeVC.timePicker.setDate(reminderForEdit!.reminderDateTime.convertToDate(), animated: true)
            } else {
                self.reminderTimeVC.reminderForEdit = nil
                self.reminderTimeVC.timePicker.setDate(Date(), animated: true)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.reminderTimeVC.view.frame = CGRect(x: 0, y: self.view.frame.height - self.totalHeight - bottomSpace, width: self.reminderTimeVC.view.frame.width, height: self.totalHeight)
            }, completion: nil)
            
        }
        
    }
    
    private func dismissReminderTimeVC() {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.reminderTimeVC.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.totalHeight)
            }, completion: nil)
        }
        
    }
 
    private func scheduleDailyReminderNotification(reminderDate: Date, notificationIdentifier: Int) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Meditate"
        content.body = "Listen to a meditation now to help clear your mind."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: reminderDate)
        dateComponents.minute = Calendar.current.component(.minute, from: reminderDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(notificationIdentifier)", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                self.showBasicAlert(title: Strings.error, message: error!.localizedDescription)
            }
        }
        
    }
    
}


// MARK: UITableView Delegates & DataSource
extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier) as! ReminderTableViewCell
        cell.enableDisableSwitch.tag = indexPath.row
        cell.enableDisableSwitch.addTarget(self, action: #selector(reminderEnableSwitchUpdate(sender:)), for: .valueChanged)
        cell.populate(dailyReminder: reminders[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let dailyReminder = reminders[indexPath.row]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(dailyReminder.reminderID)"])
            reminders.remove(at: indexPath.row)
            UserDefaults.standard.setArray(objects: reminders, key: UserDefaultKeys.dailyReminders)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
            }, completion: { (_) in
                self.showReminderTimeVC(reminderForEdit: self.reminders[indexPath.row])
            })
            
        }
        
    }
    
}


// MARK: ReminderTime Delegate
extension RemindersViewController: ReminderTimeDelegate {
    
    func didTappedOnDone(reminderDate: Date, isForEdit: Bool) {

        var dailyReminder: DailyReminder
        let dateFormatter = DateFormatter()
        
        if isForEdit == false {
            
            dailyReminder = DailyReminder()
            dailyReminder.reminderID = dailyReminder.incrementID()
            
            // Date Time
            dailyReminder.reminderDateTime = reminderDate.getDateTimeToStoreInToDB()
            
            // Time = Hour & Minute
            dateFormatter.dateFormat = "hh"
            let hour = dateFormatter.string(from: reminderDate)
            dateFormatter.dateFormat = "mm"
            let minute = dateFormatter.string(from: reminderDate)
            dailyReminder.reminderTime = "\(hour):\(minute)"
            
            // Meridiem
            dateFormatter.dateFormat = "a"
            let stringFromDate = dateFormatter.string(from: reminderDate).uppercased()
            dailyReminder.reminderMeridiem = stringFromDate

            reminders.append(dailyReminder)

        } else {
            
            dailyReminder = reminderTimeVC.reminderForEdit!
            
            // Date Time
            dailyReminder.reminderDateTime = reminderDate.getDateTimeToStoreInToDB()
            
            // Time = Hour & Minute
            dateFormatter.dateFormat = "hh"
            let hour = dateFormatter.string(from: reminderDate)
            dateFormatter.dateFormat = "mm"
            let minute = dateFormatter.string(from: reminderDate)
            dailyReminder.reminderTime = "\(hour):\(minute)"
            
            // Meridiem
            dateFormatter.dateFormat = "a"
            let stringFromDate = dateFormatter.string(from: reminderDate).uppercased()
            dailyReminder.reminderMeridiem = stringFromDate
            
        }
        
        UserDefaults.standard.setArray(objects: reminders, key: UserDefaultKeys.dailyReminders)
        dismissReminderTimeVC()
        scheduleDailyReminderNotification(reminderDate: reminderDate, notificationIdentifier: dailyReminder.reminderID)
        tableView.reloadData()

    }
    
    func didTappedOnCancel() {
        dismissReminderTimeVC()
    }
    
}
