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

    @IBAction func forwardButton(_ sender: Any) { forward() }
    @IBAction func backwardButton(_ sender: Any) { backward() }
    @IBAction func playPauseButton(_ sender: Any) { playOrPause() }
    @IBAction func shuffleButton(_ sender: Any) { cycleShuffleMode() }
    @IBAction func repeatButton(_ sender: Any) { cycleRepeatMode() }
    
    @IBOutlet weak var mediaInfo: UILabel!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var albumArt: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addSongsToQueue()
        setupNotifications()
        updatePlayPauseButton()
        displayNowPlayingItem()
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
        NSLog("playback state changed notification")
        repeatLabel.text = String(myMusicPlayer.repeatMode.rawValue)
        shuffleLabel.text = String(myMusicPlayer.shuffleMode.rawValue)
        updatePlayPauseButton()
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
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in self?.updateSlider() }
        timer.tolerance = 10.0
        
        
        switch myMusicPlayer.playbackState {
        case .playing:
            return
        default:
            NSLog("invalidate timer")
            timer.invalidate()
        }
    }
    
    func updateSlider() {
        slider.value = Float(myMusicPlayer.currentPlaybackTime)
        slider.minimumValue = 0
        slider.maximumValue = Float((myMusicPlayer.nowPlayingItem?.playbackDuration)!)
    }
    
    func updatePlayPauseButton() {
        switch myMusicPlayer.playbackState {
        case .playing:
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        default:
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
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
        repeatLabel.text = String(myMusicPlayer.repeatMode.rawValue)
        print(myMusicPlayer.repeatMode)
    }

    func cycleShuffleMode() {
        myMusicPlayer.shuffleMode = MPMusicShuffleMode(rawValue: myMusicPlayer.shuffleMode.rawValue%4+1)!
        shuffleLabel.text = String(myMusicPlayer.shuffleMode.rawValue)
        print(myMusicPlayer.shuffleMode)
    }
    
    func displayNowPlayingItem() {
        let albumArtSize = CGSize(width: 256.0, height: 256.0)

        NSLog("\(albumArtSize)")
        albumArt.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: albumArtSize)
        
        if albumArt.image == nil {
            albumArt.image = UIImage(named: "Default Album Art")
        }
        
        mediaInfo.text = myMusicPlayer.nowPlayingItem?.title
        
        repeatLabel.text = String(myMusicPlayer.repeatMode.rawValue)
        shuffleLabel.text = String(myMusicPlayer.shuffleMode.rawValue)
    }

}
