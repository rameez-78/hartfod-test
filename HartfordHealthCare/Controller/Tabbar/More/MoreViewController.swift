//
//  Tab5ViewController.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 3/4/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    private var buttons: [MoreScreenButton] = MoreScreenButton.getButtons()
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    
    // MARK: Action
    @objc private func moreButtonTapped(sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
            }, completion: { (_) in
                
                let selectedButton = self.buttons[sender.tag].title
                switch selectedButton {
                case .benefitsOfMeditation:
                    Router.shared.pushViewController(with: IntroductoryMediationViewController.identifier, navigationController: self.navigationController, storyboard: .authentication)
                case .videos:
                    Router.shared.pushViewController(with: VideosViewController.identifier, navigationController: self.navigationController, storyboard: .main)
                case .reminders:
                    Router.shared.pushViewController(with: RemindersViewController.identifier, navigationController: self.navigationController, storyboard: .main)
                case .meditationHistory:
                    Router.shared.pushViewController(with: MeditationHistoryViewController.identifier, navigationController: self.navigationController, storyboard: .main)
                case .support:
                    Router.shared.pushViewController(with: TechSupportViewController.identifier, navigationController: self.navigationController, storyboard: .main)
                case .about:
                    Router.shared.pushViewController(with: AboutViewController.identifier, navigationController: self.navigationController, storyboard: .main)
                }

            })
            
        }
        
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
}


// MARK: UITableView Delegates & DataSource
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier) as! MoreTableViewCell
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addTarget(self, action: #selector(moreButtonTapped(sender:)), for: .touchUpInside)
        cell.moreButton.setTitle(buttons[indexPath.row].title.rawValue, for: .normal)
        return cell
        
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let button = buttons[indexPath.row]
        if button.isCellRowAnimated == false {
            button.isCellRowAnimated = true
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
        return 70.0
    }
    
}
