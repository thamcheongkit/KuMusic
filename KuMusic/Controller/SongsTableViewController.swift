//
//  MusicListTableViewController.swift
//  KuMusic
//
//  Created by ck on 10/12/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsTableViewController: UITableViewController {
    
    private let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).myMusicPlayer
    
    var songs: [MPMediaItem]? {
        didSet {
            found = false
            tableView.reloadData()
        }
    }
    
    var lastIndexPath: IndexPath?
    var previousSong: MPMediaItem?
    var found = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if songs != nil {
            return 1
        } else {
            return super.numberOfSections(in: tableView)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let songs = songs {
            return songs.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let songs = songs {
            let song = songs[indexPath.row]
            cell.textLabel?.text = song.title
            cell.detailTextLabel?.text = "\(song.artist!) | \(song.albumTitle!)"
            cell.imageView?.image = nil
        }
        
        if !found {
            if let song = myMusicPlayer.musicPlayer.nowPlayingItem,
                songs?[indexPath.row] == song,
                let image = UIImage(named: "playstate") {
                cell.imageView?.image = image
                found = true
            }
        }
        
//        else {
//            if let lastIndexPath = lastIndexPath,
//                lastIndexPath == indexPath,
//                let image = UIImage(named: "playstate") {
//                cell.imageView?.image = image
//            }
//        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMedia = songs?[indexPath.row],
            previousSong != selectedMedia {
            
//            if let lip = lastIndexPath {
//                if lip != indexPath {
//                    lastIndexPath = indexPath
//                    tableView.reloadRows(at: [lip, indexPath], with: UITableViewRowAnimation.none)
//                } else {
//                    tableView.deselectRow(at: indexPath, animated: true)
//                }
//            } else {
//                lastIndexPath = indexPath
//                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
//            }
            
            myMusicPlayer.musicPlayer.setQueue(with: MPMediaItemCollection(items: [selectedMedia]))
            myMusicPlayer.musicPlayer.prepareToPlay()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
}

extension SongsTableViewController {
    
    @objc func nowPlayingChanged(notification: NSNotification) {
        if let song = myMusicPlayer.musicPlayer.nowPlayingItem {
            if previousSong == nil || previousSong != song {
                found = false
                tableView.reloadData()
                previousSong = myMusicPlayer.musicPlayer.nowPlayingItem
            }
        }
    }
    
    @objc func playbackStateChanged(notification: NSNotification) { }
    
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
}
