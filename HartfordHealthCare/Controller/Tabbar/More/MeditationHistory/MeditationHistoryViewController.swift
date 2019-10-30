//
//  MeditationHistoryViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 26/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class MeditationHistoryViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    private var meditationSessions: [MeditationSession] = []
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        populateDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(populateDataSource), name: .refreshMeditationSessionHistoryUI, object: nil)
        
    }
    
    @objc private func populateDataSource() {

        guard let participantID = UserDefaults.standard.value(forKey: UserDefaultKeys.participantID) as? String else {
            return
        }
        let sessions = DBManager.shared().getMeditationSessions()

        meditationSessions.removeAll()
        meditationSessions += sessions
        meditationSessions.removeAll { (session) -> Bool in
            
            if session.userParticipantID != participantID {
                return true
            } else {
                let duration = session.completedDuration
                if duration == "0" {
                    return true
                } else if let minutes = duration.split(separator: ".").first, minutes == "0" {
                    return true
                } else {
                    return false
                }
            }
            
        }
        tableView.reloadData()

    }
    
}


// MARK: UITableView Delegates & DataSource
extension MeditationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meditationSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeditationHistoryTableViewCell.identifier) as! MeditationHistoryTableViewCell
        cell.populate(meditationSession: meditationSessions[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let meditationSession = meditationSessions[indexPath.row]
        if meditationSession.isCellRowAnimated == false {
            meditationSession.isCellRowAnimated = true
            cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
            cell.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
