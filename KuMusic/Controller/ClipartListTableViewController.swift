//
//  ClipartListTableViewController.swift
//  KuMusic
//
//  Created by ck on 11/12/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import UIKit
import MediaPlayer

class ClipartListTableViewController: UITableViewController {
    
    private let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).myMusicPlayer
    
    var mediaType: KuMusic.MediaType?
    
    var mediaItems: [MPMediaItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if mediaItems != nil {
            return 1
        } else {
            return super.numberOfSections(in: tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let mediaItems = mediaItems {
            return mediaItems.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Clipart Cell", for: indexPath)
        
        if let mediaType = mediaType,
            let mediaItems = mediaItems {
            switch mediaType {
            case .artist:
                let mediaItem = mediaItems[indexPath.row]
                cell.textLabel?.text = mediaItem.artist
            case .album:
                let mediaItem = mediaItems[indexPath.row]
                cell.textLabel?.text = mediaItem.albumTitle
            }
        }
        
//        if let mediaItems = mediaItems {
//            let mediaItem = mediaItems[indexPath.row]
//            cell.textLabel?.text = mediaItem.artist
//        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let title = title {
            switch title {
            case "Albums":
                print("segue from album")
                if let songsVC = segue.destination as? SongsTableViewController,
                    let sender = sender as? UITableViewCell,
                    let albumName = sender.textLabel?.text {
                    songsVC.songs = myMusicPlayer.songsByAlbum(albumName)
                }
            case "Artists":
                print("segue from artists")
                if let songsVC = segue.destination as? SongsTableViewController,
                    let sender = sender as? UITableViewCell,
                    let artistName = sender.textLabel?.text {
                    songsVC.songs = myMusicPlayer.songsByArtist(artistName)
                }
            default:
                return
            }
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
