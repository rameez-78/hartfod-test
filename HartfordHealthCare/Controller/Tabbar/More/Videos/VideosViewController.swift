//
//  VideosViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 26/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideosViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    private var videos: [Video] = Video.getVideos()
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
    }
    
    private func playVideo(url: String) {
        
        guard let videoURL = URL(string: url) else {
            return
        }
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
        
    }
    
}


// MARK: UITableView Delegates & DataSource
extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as! VideoTableViewCell
        cell.populate(video: videos[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let video = videos[indexPath.row]
        if video.isCellRowAnimated == false {
            video.isCellRowAnimated = true
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
        return 84
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
                self.playVideo(url: self.videos[indexPath.row].url)
            })
            
        }
        
    }
    
}
