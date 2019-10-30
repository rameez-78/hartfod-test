//
//  MeditationListingViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MeditationListingViewController: UIViewController, IndicatorInfoProvider {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    public var indicatorInfo: IndicatorInfo = "For Pain"
    public var meditations: [Meditation] = []
    private let listingPadding: CGFloat = 16.0
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    
    // MARK: Action
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: listingPadding, left: 0, bottom: listingPadding, right: 0)
        
    }
    
}


// MARK: UITableView Delegates & DataSource
extension MeditationListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meditations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeditationTableViewCell.identifier) as! MeditationTableViewCell
        cell.populate(meditation: meditations[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let meditation = meditations[indexPath.row]
        if meditation.isCellRowAnimated == false {
            meditation.isCellRowAnimated = true
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
                let meditation = self.meditations[indexPath.row]
                if meditation.meditationURL != "" {
                    self.tabBarController?.tabBar.isHidden = true
                    Router.shared.pushMediaPlayerViewController(navigationController: self.navigationController, meditation: meditation)
                }
            })
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if Device.isIPhone5() {
            return 100.0
        } else {
            return (view.frame.height / 4) - 8
        }
        
    }
    
}
