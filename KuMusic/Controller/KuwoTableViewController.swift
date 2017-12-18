//
//  KuwoTableViewController.swift
//  KuMusic
//
//  Created by ck on 18/12/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import UIKit
import AVKit

class KuwoTableViewController: UITableViewController, UISearchBarDelegate, AVAudioPlayerDelegate {
    
    var searchTerm: String? {
        didSet {
            KuwoAPI(searchTerm, page: page) { songs in
                self.songs = songs
            }
        }
    }

    var nowplayingid: String?
    
    var player: AVAudioPlayer?
    
//    let downloadIndicator = UIActivityIndicatorView()
    
    var page: Int = 0
    
    var songs: [Song]? {
        didSet {
            nowplayingid = nil
            tableView.reloadData()
        }
    }
    
    private var searchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        addSearchController()
        
//        downloadIndicator.startAnimating()
//        downloadIndicator.hidesWhenStopped = true
        
        KuwoAPI(searchTerm, page: page) { songs in
            self.songs = songs
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Kuwo Cell", for: indexPath)
        
        if let songs = songs {
            cell.textLabel?.text = songs[indexPath.row].name
            cell.detailTextLabel?.text = "\(songs[indexPath.row].artist) | \(songs[indexPath.row].album)"
            cell.imageView?.image = nil
            
            if nowplayingid == songs[indexPath.row].id {
                cell.imageView?.image = UIImage(named: "playstate")
            }
            
        }
        
        return cell
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text,
            text != "" {
            searchTerm = text
        }
        
        if let sc = searchController {
            sc.isActive = false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let songs = songs {
            
            nowplayingid = songs[indexPath.row].id
            
//            downloadIndicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            tableView.reloadData()
            
            KuwoSongURL(id: songs[indexPath.row].id) { streamurl in
                if let url = URL(string: streamurl) {
                    download(url) { (data) in
                        if self.nowplayingid == songs[indexPath.row].id {
                            DispatchQueue.main.async {
                                do {
                                    self.player = try AVAudioPlayer.init(data: data)
                                    if let player = self.player {
                                        player.play()
                                        print("play without error")
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        self.prepareBackgroundPlayback()
                                    }
//                                    self.downloadIndicator.stopAnimating()
                                } catch let error {
                                    print(error.localizedDescription)
                                    print("error playing")
                                }
                            }
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                
//                DispatchQueue.main.async {
//                    if let url = URL(string: streamurl) {
//                        do {
//                            self.player = try AVAudioPlayer.init(contentsOf: url)
//
//                            if let player = self.player {
//                                player.prepareToPlay()
//                                player.play()
//                                print("playing")
//                                print(url)
//                            }
//
//                        } catch let error {
//                            print(error.localizedDescription)
//                        }
//                    } else {
//                        print("invalid URL")
//                    }
//                }
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}

extension KuwoTableViewController {
    func addSearchController() {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = "Search “周杰伦”"
        searchController = sc
        navigationItem.searchController = sc
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func prepareBackgroundPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
