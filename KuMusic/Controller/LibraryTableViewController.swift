//
//  LibraryTableViewController.swift
//  KuMusic
//
//  Created by ck on 11/12/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    let myMusicPlayer = (UIApplication.shared.delegate as? AppDelegate)?.myMusicPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Songs":
                if let songs = myMusicPlayer?.query(.songs),
                    let songsVC = segue.destination as? SongsTableViewController {
                    songsVC.songs = songs
                }
            case "Show Artists":
                if let clipartVC = segue.destination as? ClipartListTableViewController {
                    let artists = myMusicPlayer?.query(.artists)
                    clipartVC.title = "Artists"
                    clipartVC.mediaType = KuMusic.MediaType.artist
                    clipartVC.mediaItems = artists
                }
            case "Show Albums":
                if let clipartVC = segue.destination as? ClipartListTableViewController {
                    let albums = myMusicPlayer?.query(.albums)
                    clipartVC.title = "Albums"
                    clipartVC.mediaType = KuMusic.MediaType.album
                    clipartVC.mediaItems = albums
                }
            default:
                return
            }
        }
    }
    
    // MARK: - Table view data source
    
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
