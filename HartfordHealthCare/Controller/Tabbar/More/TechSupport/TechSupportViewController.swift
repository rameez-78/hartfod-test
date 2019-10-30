//
//  TechSupportViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 30/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import MessageUI

class TechSupportViewController: UIViewController {
    
    
    // MARK: Outlets
    
    
    // MARK: Properties
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    @IBAction func supportButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = .identity
            }, completion: { (_) in
                self.saveClickSession(clickName: "Tech Support", clickType: "Email Link")
                self.sendEmail(on: "info@c9ohealth.com")
            })
            
        }
        
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        view.addAppThemeGradient()
    }
    
    private func saveClickSession(clickName: String, clickType: String) {
        
        if DBManager.shared().linkSessionsAreSubscribed {
            let linkSession = LinkSession()
            linkSession.id = linkSession.incrementID()
            linkSession.clickTime = Date().getDateStringForSession()
            linkSession.clickName = "\(clickName) - \(clickType)"
            if let participantID = UserDefaults.standard.value(forKey: UserDefaultKeys.participantID) as? String {
                linkSession.userParticipantID = participantID
            }
            DBManager.shared().add(object: linkSession, overwrite: false)
        }
        
    }
    
    private func sendEmail(on emailAddress: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddress])
            present(mail, animated: true)
        } else {
            guard let url = URL(string: "mailto:\(emailAddress)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
}


// MARK: MFMailComposeViewController Delegate
extension TechSupportViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
