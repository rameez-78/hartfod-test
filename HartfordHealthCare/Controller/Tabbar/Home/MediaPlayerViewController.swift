//
//  MediaPlayerViewController.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 6/6/18.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import RealmSwift

class MediaPlayerViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var meditationNameLabel: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playerControlsView: MediaPlayerControlsBackground!
    @IBOutlet weak var reverseView: BackwardIcon!
    @IBOutlet weak var forwardView: ForwardIcon!
    
    
    // MARK: Propeties
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private let session: AVAudioSession = AVAudioSession.sharedInstance()
    private let commandCenter = MPRemoteCommandCenter.shared()
    private var timeObserverToken: Any?
    public var currentMeditation: Meditation?
    private var playerCurrentTime: CMTime {
        return (player!.currentItem!.duration - player!.currentItem!.currentTime())
    }
    private let forwardReverseDurationInSec: Double = 5
    private var isUserScrubbingSeekbar: Bool = false
    private var isSessionSaved: Bool = false
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAudioSession()
        setupPlayer()
        configureCommandCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    @IBAction func playerSeekbarValueChanged(_ sender: UISlider) {
        
        isUserScrubbingSeekbar = false
        let seconds: Double = Double(sender.value)
        let targetTime: CMTime = CMTime(seconds: seconds, preferredTimescale: player?.currentTime().timescale ?? 600)
        DispatchQueue.main.async {
            self.player?.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
            self.setLockInfo()
        }
        
    }
    
    @IBAction func playerSeekbarScrubbing(_ sender: UISlider) {
        
        isUserScrubbingSeekbar = true
        let seconds = Double(sender.value)
        updatePlayerTimeLabelControls(currentTime: seconds)
        
    }
    
    
    @IBAction func playbuttonTapped() {
        
        if playerControlsView.isActivityViewVisible == false {
            if player?.rate == 0 {
                DispatchQueue.main.async {
                    self.player?.play()
                    self.hidePlayIconWithAnimation()
                    self.setLockInfo()
                }
            } else {
                pausePlayer()
            }
        }
        
    }
    
    @IBAction func backButtonTapped() {
        
        if isSessionSaved == false {
            let playerPercentCompleted = Int((playbackSlider.value / playbackSlider.maximumValue) * 100)
            if playerPercentCompleted != 100 {
                saveMediationSessionIntoDB(percentage: playerPercentCompleted)
            }
        }
        player?.pause()
        removePeriodicTimeObserver()
        player = nil
        setLockInfo()
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func reverseButtonTapped() {
        
        if playerControlsView.isActivityViewVisible == false {
            
            guard let mediaPlayer = player else {
                return
            }
            
            let currentTimeInSeconds = mediaPlayer.currentTime().seconds
            let targetTime: CMTime
            if currentTimeInSeconds > forwardReverseDurationInSec {
                targetTime = CMTimeMake(value: Int64(currentTimeInSeconds - forwardReverseDurationInSec), timescale: 1)
            } else {
                targetTime = CMTimeMake(value: 0, timescale: 1)
            }
            DispatchQueue.main.async {
                mediaPlayer.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
                self.setLockInfo()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.reverseView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.reverseView.transform = .identity
                })
            })
            
        }
        
    }
    
    @IBAction func forwardButtonTapped() {
        
        if playerControlsView.isActivityViewVisible == false {
            guard let mediaPlayer = player else {
                return
            }
            
            let currentTimeInSeconds = mediaPlayer.currentTime().seconds
            let targetTime: CMTime = CMTimeMake(value: Int64(currentTimeInSeconds + forwardReverseDurationInSec), timescale: 1)
            DispatchQueue.main.async {
                mediaPlayer.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
                self.setLockInfo()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.forwardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.forwardView.transform = .identity
                })
            })
            
        }
        
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        playbackSlider.setThumbImage(UIImage(named: "transparent"), for: .normal)
        playerControlsView.showSpinner(isUserInteractionEnabled: true, isForMediaPlayer: true)
        pauseView.transform = CGAffineTransform(scaleX: 0, y: 0)
        playerControlsView.backgroundColor = currentMeditation!.iconColor
        
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
        
        guard let url = URL(string: currentMeditation?.meditationURL ?? "") else {
            showBasicAlert(title: Strings.error, message: Strings.unExpectedResult)
            self.playerControlsView.removeSpinner()
            return
        }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let duration: CMTime = playerItem.asset.duration
        let durationSeconds: Float64 = CMTimeGetSeconds(duration)
        if CMTimeGetSeconds(duration) == 0 {
            showErrorAlert()
            self.playerControlsView.removeSpinner()
            return
        }
        
        let mySecs = Int(durationSeconds) % 60
        let myMins = Int(durationSeconds / 60)
        let durationTime = "-" + String(myMins) + ":" + String(mySecs)
        durationTimeLabel.text = durationTime
        playbackSlider.maximumValue = Float(durationSeconds)
        playbackSlider.isContinuous = false
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) -> Void in
            
            if self.player!.currentItem?.status == .readyToPlay {
                
                if self.playerControlsView.isActivityViewVisible {
                    self.playerControlsView.removeSpinner()
                    self.meditationNameLabel.text = self.currentMeditation!.name
                    self.hidePlayIconWithAnimation()
                }
                if self.isUserScrubbingSeekbar == false {
                    let timeInSeconds: Float64 = CMTimeGetSeconds(time)
                    self.updatePlayerTimeLabelControls(currentTime: timeInSeconds)
                    self.playbackSlider.setValue(Float(timeInSeconds), animated: false)
                }
                self.setLockInfo()
                
            }
            
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        
        DispatchQueue.main.async {
            self.saveMediationSessionIntoDB(percentage: 100)
            self.player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
            self.pausePlayer()
        }
        
    }
    
    private func updatePlayerTimeLabelControls(currentTime: Double) {
        
        DispatchQueue.main.async {
            
            // Current Time
            let currentTimeString: String
            let currentTimeMinutes = Int(currentTime / 60)
            let currentTimeSeconds = Int(currentTime.truncatingRemainder(dividingBy: 60))
            if currentTimeSeconds < 10 {
                currentTimeString = "\(currentTimeMinutes):0\(currentTimeSeconds)"
            } else {
                currentTimeString = "\(currentTimeMinutes):\(currentTimeSeconds)"
            }
            self.currentTimeLabel.text = currentTimeString
            
            // Remaining Time
            let remainingTimeString: String
            let durationSeconds: Double = CMTimeGetSeconds((self.player?.currentItem?.duration)!)
            let remainingTime = durationSeconds - currentTime
            let remainingTimeSeconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
            let remainingTimeMinutes = Int(remainingTime / 60)
            if remainingTimeSeconds < 10 {
                remainingTimeString = "-\(remainingTimeMinutes):0\(remainingTimeSeconds)"
            } else {
                remainingTimeString = "-\(remainingTimeMinutes):\(remainingTimeSeconds)"
            }
            self.durationTimeLabel.text = remainingTimeString
            
        }
        
    }
    
    private func saveMediationSessionIntoDB(percentage: Int) {
        
        if DBManager.shared().myMeditationSessionsAreSubscribed {
            let meditationSession = MeditationSession()
            meditationSession.id = meditationSession.incrementID()
            meditationSession.playDateTime = Date()
            meditationSession.playDate = Date().getDateStringForSession()
            meditationSession.meditationName = currentMeditation!.name
            meditationSession.completedPercentage = "\(percentage)%"
            meditationSession.completedDuration = calculateCompletedDuration()
            if let participantID = UserDefaults.standard.value(forKey: UserDefaultKeys.participantID) as? String {
                meditationSession.userParticipantID = participantID
            }
            DBManager.shared().add(object: meditationSession, overwrite: false)
            isSessionSaved = true
        }
        
    }
    
    private func calculateCompletedDuration() -> String {
        
        guard let currentTimeInSeconds = player?.currentTime().seconds else {
            return "00:00"
        }
        let completedDuration: String
        let minutes = Int(currentTimeInSeconds / 60)
        let seconds = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        if seconds < 30 {
            completedDuration = "\(minutes)"
        } else {
            completedDuration = "\(minutes).5"
        }
        return completedDuration
        
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
    
    func removePeriodicTimeObserver() {
        
        // If a time observer exists, remove it
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
    }
    
    private func showErrorAlert() {
        
        let title: String
        let message: String
        title = "Something Went Wrong"
        message = "The meditation could not be played, please check your connection and try again."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "Back", style: .default) { (_) in
            _ = self.perform(#selector(self.backButtonTapped))
        }
        alert.addAction(backAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    open func seekToFor(_ event: MPChangePlaybackPositionCommandEvent) {
        
        player?.seek(to: CMTimeMake(value: Int64(event.positionTime), timescale: 1))
        setLockInfo()
        
    }
    
    //MARK: - Command Center
    func configureCommandCenter() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        commandCenter.playCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sself = self else { return .commandFailed }
            sself.playbuttonTapped()
            return .success
        })
        commandCenter.pauseCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sself = self else { return .commandFailed }
            sself.playbuttonTapped()
            return .success
        })
        
        let skipBackwardIntervalCommand: MPSkipIntervalCommand = self.commandCenter.skipBackwardCommand
        skipBackwardIntervalCommand.isEnabled = true
        skipBackwardIntervalCommand.preferredIntervals = [NSNumber(value: forwardReverseDurationInSec)]
        
        self.commandCenter.skipBackwardCommand.addTarget(handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sself = self else { return .commandFailed }
            sself.reverseButtonTapped() //This command moves the track back 15 seconds in time.
            return .success
        })
        
        let skipForwardIntervalCommand: MPSkipIntervalCommand = self.commandCenter.skipForwardCommand
        skipForwardIntervalCommand.isEnabled = true
        skipForwardIntervalCommand.preferredIntervals = [NSNumber(value: forwardReverseDurationInSec)]
        
        self.commandCenter.skipForwardCommand.addTarget(handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sself = self else { return .commandFailed }
            sself.forwardButtonTapped() //This command moves the track forward 15 seconds in time
            return .success
        })
        
        if #available(iOS 9.1, *) {
            self.commandCenter.changePlaybackPositionCommand.addTarget(handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
                guard let sself = self else { return .commandFailed }
                sself.seekToFor(_: event as! MPChangePlaybackPositionCommandEvent)
                return .success
            })
        } else {
            // Fallback on earlier versions
        }
        setLockInfo()
        
    }
    
    //MARK: - Now Playing Info
    private func setLockInfo() {
        
        if player == nil {
            print("This player is nil!")
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        let title = currentMeditation!.name
        let image = UIImage(named: currentMeditation!.meditationImageName)!.squared()
        let artwork = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
            return image
        })
        
        let duration = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 1))
        var elapsedTime = CMTimeGetSeconds(player?.currentItem?.currentTime() ?? CMTime(seconds: 0, preferredTimescale: 1))
        if elapsedTime == duration {
            elapsedTime = Float64(0)
            player?.pause()
        }

        let songInfo: [String: Any] = [MPMediaItemPropertyTitle: title,
                                       MPMediaItemPropertyArtwork: artwork,
                                       MPNowPlayingInfoPropertyElapsedPlaybackTime: elapsedTime,
                                       MPNowPlayingInfoPropertyPlaybackRate: 1.0,
                                       MPMediaItemPropertyPlaybackDuration: duration]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
    return input.rawValue
}
