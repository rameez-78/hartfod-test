//
//  IntroductoryMediationViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 19/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit
import AVFoundation

class IntroductoryMediationViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var skipDescriptionLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    
    // MARK: Properties
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private let session: AVAudioSession = AVAudioSession.sharedInstance()
    private var timeObserverToken: Any?
    private var isPlayingFirstTime: Bool = true

    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: UserDefaultKeys.isOnBoardingCompleted) == nil {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        pausePlayer()
    }

    
    // MARK: Action
    @IBAction func playButtonTapped() {

        if view.isActivityViewVisible == false {
            if player?.rate == 0 {
                DispatchQueue.main.async {
                    self.player?.play()
                    if self.isPlayingFirstTime {
                        self.isPlayingFirstTime = false
                        self.view.showSpinner(isUserInteractionEnabled: true, isForMediaPlayer: false)
                    } else {
                        self.hidePlayIconWithAnimation()
                    }
                }
            } else {
                pausePlayer()
            }
        }
        
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        Router.shared.pushViewController(with: ReminderTimeSelectionViewController.identifier, navigationController: self.navigationController, storyboard: .authentication)
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        setupAudioSession()
        setupPlayer()
        pauseView.transform = CGAffineTransform(scaleX: 0, y: 0)
        if UserDefaults.standard.value(forKey: UserDefaultKeys.isOnBoardingCompleted) == nil {
            UserDefaults.standard.setValue(OnBoardingScreen.introductoryMeditation.rawValue, forKey: UserDefaultKeys.onBoardingProcessScreen)
        } else {
            DispatchQueue.main.async {
                self.skipDescriptionLabel.isHidden = true
                self.skipButton.isHidden = true
            }
        }

    }
    
    private func setupAudioSession() {
        
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.spokenAudio)), options: [.interruptSpokenAudioAndMixWithOthers, .allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session: \(error.localizedDescription)")
        }
        
    }
    
    func setupPlayer() {
        
        guard let url = URL(string: "https://cloud-hosting-mobilehub-1903924678.s3.amazonaws.com/RXMeditations/Sabrina_1901_Benefits+Of+Meditation.mp3") else {
            showBasicAlert(title: Strings.error, message: Strings.unExpectedResult)
            return
        }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) -> Void in
            
            if self.player!.currentItem?.status == .readyToPlay {
                
                if self.view.isActivityViewVisible {
                    self.view.removeSpinner()
                    self.hidePlayIconWithAnimation()
                }
                
            }
            
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        
        DispatchQueue.main.async {
            self.player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
            self.pausePlayer()
            if UserDefaults.standard.value(forKey: UserDefaultKeys.isOnBoardingCompleted) == nil {
                Router.shared.pushViewController(with: ReminderTimeSelectionViewController.identifier, navigationController: self.navigationController, storyboard: .authentication)
            }
        }
        
    }
    
    private func hidePlayIconWithAnimation() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        pauseView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.playView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }, completion: { _ in
            
            self.playView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.2, animations: {
                self.pauseView.transform = .identity
            }, completion: { (_) in
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
        })
        
    }
    
    private func hidePauseIconWithAnimation() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        playView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.pauseView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }, completion: { _ in
            
            self.pauseView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.2, animations: {
                self.playView.transform = .identity
            }, completion: { (_) in
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
        })
        
    }
    
    private func pausePlayer() {
        
        player?.pause()
        hidePauseIconWithAnimation()
        
    }
    
    private func removePeriodicTimeObserver() {
        
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
    return input.rawValue
}
