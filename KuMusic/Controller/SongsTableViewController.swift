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
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if songs != nil {
            return 1
        } else {
            return super.numberOfSections(in: tableView)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        if let nowPlayingItem = myMusicPlayer.musicPlayer.nowPlayingItem,
            let songs = songs,
            songs[indexPath.row] == nowPlayingItem,
            let image = UIImage(named: "playstate") {
            NSLog("found same mediaitem!")
            cell.imageView?.image = image
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMedia = songs?[indexPath.row] {
            myMusicPlayer.musicPlayer.setQueue(with: MPMediaItemCollection(items: [selectedMedia]))
            myMusicPlayer.musicPlayer.prepareToPlay()
        }
    }

}

extension SongsTableViewController {
    
    @objc func nowPlayingChanged(notification: NSNotification) {
        NSLog("now playing did changed!")
        tableView.reloadData()
    }
    
    @objc func playbackStateChanged(notification: NSNotification) {
        NSLog("playback state changed notification")
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
}
