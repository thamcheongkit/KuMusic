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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayNowPlayingItem()
        
        addSongsToQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        myMusicPlayer.beginGeneratingPlaybackNotifications()
    }

}

extension FirstViewController {
    func addSongsToQueue() {
        // Instantiate a new music player
        myMusicPlayer.setQueue(with: MPMediaQuery.songs())
        
//        if let songs = MPMediaQuery.songs().items {
//            for song in songs {
//                print(song.title)
//            }
//        }
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
        case .interrupted:
            print("was playing, now interrpted")
            pause()
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
        mediaInfo.text = myMusicPlayer.nowPlayingItem?.title
    }

}
