//
//  KuMusic.swift
//  KuMusic
//
//  Created by ck on 28/11/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import Foundation
import MediaPlayer

class KuMusic {
    let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    func addSongsToQueue() {
        // Instantiate a new music player
        musicPlayer.setQueue(with: MPMediaQuery.songs())
    }

    enum MediaType {
        case artist
        case album
    }
    
    enum Queries {
        case artists
        case songs
        case albums
    }
    
    func query(_ type: Queries) -> [MPMediaItem]? {
        switch type {
        case .songs:
            return MPMediaQuery.songs().items
        case .artists:
            if let collections = MPMediaQuery.artists().collections {
                let items = collections.map({$0.items[0]})
                return items
            } else {
                return []
            }
        case .albums:
            if let collections = MPMediaQuery.albums().collections {
                let items = collections.map({$0.items[0]})
                return items
            } else {
                return []
            }
        }
    }
    
    func songsByArtist(_ artist: String) -> [MPMediaItem]? {
        let songsByArtists = MPMediaQuery.artists().collections
        let songsByArtist = songsByArtists?.filter({ $0.items[0].artist == artist })
        return songsByArtist?[0].items
    }
    
    func songsByAlbum(_ album: String) -> [MPMediaItem]? {
        let songsByAlbums = MPMediaQuery.albums().collections
        let songsByAlbum = songsByAlbums?.filter({ $0.items[0].albumTitle == album })
        return songsByAlbum?[0].items
    }
    
    

//    func queryArtists() -> [MPMediaItem] {
//        if let collections = MPMediaQuery.artists().collections {
//            let items = collections.map({$0.items[0]})
//            return items
//        }
//        else {
//            return []
//        }
//    }

//    func querySongs() -> [MPMediaItem]? {
//        return MPMediaQuery.songs().items
//    }
    
    func play() {
        // Start playing from the beginning of the queue
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func playOrPause() {
        switch (musicPlayer.playbackState) {
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
        musicPlayer.skipToNextItem()
    }
    
    func backward() {
        musicPlayer.skipToPreviousItem()
    }
    
    func cycleRepeatMode() {
        musicPlayer.repeatMode = MPMusicRepeatMode(rawValue: musicPlayer.repeatMode.rawValue%4+1)!
        print(musicPlayer.repeatMode)
    }
    
    func cycleShuffleMode() {
        musicPlayer.shuffleMode = MPMusicShuffleMode(rawValue: musicPlayer.shuffleMode.rawValue%4+1)!
        print(musicPlayer.shuffleMode)
    }
    
}
