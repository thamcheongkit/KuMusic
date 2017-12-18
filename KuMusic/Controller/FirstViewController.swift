//
//  FirstViewController.swift
//  KuMusic
//
//  Created by ck on 28/11/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import UIKit
import MediaPlayer

class FirstViewController: UIViewController {
    
    let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).myMusicPlayer.musicPlayer
    
    var timer: Timer?
    
    @IBAction func forwardButton(_ sender: Any) { forward() }
    @IBAction func backwardButton(_ sender: Any) { backward() }
    @IBAction func playPauseButton(_ sender: Any) { playOrPause() }
    @IBAction func shuffleButton(_ sender: Any) { cycleShuffleMode() }
    @IBAction func repeatButton(_ sender: Any) { cycleRepeatMode() }
    
    @IBAction func slider(_ sender: UISlider) { drag(sender) }
    
    @IBOutlet weak var mediaInfo: UILabel!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var albumArt: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addSongsToQueue()
        setupNotifications()
        updatePlayPauseButton()
        displayNowPlayingItem()
        updateSliderTimer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        myMusicPlayer.beginGeneratingPlaybackNotifications()
    }
    
}

extension FirstViewController {
    
    @objc func nowPlayingChanged(notification: NSNotification) {
        NSLog("now playing did changed!")
        displayNowPlayingItem()
    }
    
    @objc func playbackStateChanged(notification: NSNotification) {
        updateRepeatLabel()
        updateShuffleLabel()
        updatePlayPauseButton()
    }
    
    func drag(_ sender: UISlider) {
        myMusicPlayer.currentPlaybackTime = TimeInterval(sender.value)
        updateSliderTimer()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nowPlayingChanged(notification:)),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playbackStateChanged(notification:)),
            name: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
    }
    
    func updateSliderTimer() {
        if let t = timer {
            t.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in self?.updateSlider() }
    }
    
    func updateSlider() {
        if let duration = myMusicPlayer.nowPlayingItem?.playbackDuration {
            slider.value = Float(myMusicPlayer.currentPlaybackTime)
            slider.minimumValue = 0
            slider.maximumValue = Float(duration)
//            print(myMusicPlayer.currentPlaybackTime)
        }
    }
    
    func updatePlayPauseButton() {
        switch myMusicPlayer.playbackState {
        case .playing:
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        default:
            playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    func addSongsToQueue() {
        // Instantiate a new music player
        myMusicPlayer.setQueue(with: MPMediaQuery.songs())
    }
    
    func play() {
        // Start playing from the beginning of the queue
        myMusicPlayer.play()
    }
    
    func pause() {
        myMusicPlayer.pause()
    }
    
    func playOrPause() {
        switch (myMusicPlayer.playbackState) {
        case .stopped:
            print("was stopped, now playing")
            play()
//        case .interrupted:
//            print("was playing, now interrpted")
//            pause()
        case .paused:
            print("was paused, now playing")
            play()
        case .playing:
            print("was playing, now pausing")
            pause()
        default: ()
        }
    }
    
    func forward() {
        myMusicPlayer.skipToNextItem()
        displayNowPlayingItem()
    }
    
    func backward() {
        myMusicPlayer.skipToPreviousItem()
        displayNowPlayingItem()
    }
    
    func cycleRepeatMode() {
        myMusicPlayer.repeatMode = MPMusicRepeatMode(rawValue: myMusicPlayer.repeatMode.rawValue%4+1)!
        updateRepeatLabel()
    }
    
    func updateRepeatLabel() {
        //        repeatLabel.text = String(myMusicPlayer.repeatMode.name)
        
        switch myMusicPlayer.repeatMode {
        case .none:
            repeatLabel.text = "None"
        case .one:
            repeatLabel.text = "One"
        case .all:
            repeatLabel.text = "All"
        case .default:
            repeatLabel.text = "None"
        }
    }

    func cycleShuffleMode() {
//        myMusicPlayer.shuffleMode = MPMusicShuffleMode(rawValue: myMusicPlayer.shuffleMode.rawValue%2+2)!
        
        switch myMusicPlayer.shuffleMode {
        case .off:
            myMusicPlayer.shuffleMode = .songs
        case .songs:
            myMusicPlayer.shuffleMode = .off
        default:
            myMusicPlayer.shuffleMode = .songs
        }
        
        updateShuffleLabel()
    }
    
    func updateShuffleLabel() {
        switch myMusicPlayer.shuffleMode {
        case .off:
            shuffleLabel.text = "Off"
        case .songs:
            shuffleLabel.text = "On"
        default:
            shuffleLabel.text = "Off"
        }
    }
    
    func displayNowPlayingItem() {
        let albumArtSize = CGSize(width: 256.0, height: 256.0)

        albumArt.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: albumArtSize)
        
        if albumArt.image == nil {
            albumArt.image = UIImage(named: "Default Album Art")
        }
        
        mediaInfo.text = myMusicPlayer.nowPlayingItem?.title
        
        updateRepeatLabel()
        updateShuffleLabel()
    }

}


extension MPMusicShuffleMode {
    var name: String {
        get { return String(describing: self) }
    }
}

extension MPMusicRepeatMode {
    var name: String {
        get { return String(describing: self) }
    }
}
