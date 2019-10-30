//
//  ReminderTimeViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

protocol ReminderTimeDelegate: class {
    func didTappedOnDone(reminderDate: Date, isForEdit: Bool)
    func didTappedOnCancel()
}

class ReminderTimeViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    // MARK: Properties
    public weak var delegate: ReminderTimeDelegate?
    public var reminderForEdit: DailyReminder?
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.didTappedOnCancel()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if reminderForEdit != nil {
            delegate?.didTappedOnDone(reminderDate: timePicker.date, isForEdit: true)
        } else {
            delegate?.didTappedOnDone(reminderDate: timePicker.date, isForEdit: false)
        }
        
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        timePicker.locale = Locale(identifier: "en_US")
    }
    
}
