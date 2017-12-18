//
//  Kuwo.swift
//  KuMusic
//
//  Created by ck on 18/12/2017.
//  Copyright © 2017 ck. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func KuwoAPI(_ searchTerm: String?, page: Int = 0, completionhandler: @escaping ([Song]) -> Void) {
    if let searchTerm = searchTerm {
        let urlstring = "http://search.kuwo.cn/r.s?all=\(searchTerm)&ft=music&itemset=web_2013&client=kt&pn=\(page)&rn=50&rformat=json&encoding=utf8"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let urlstring = urlstring,
            let url = URL.init(string: urlstring) {
            print(urlstring)
            Alamofire.request(url).responseString { (response) in
                DispatchQueue.main.async {
                    if let jsonstring = response.result.value {
                        let validjson = jsonstring.replacingOccurrences(of: "\'", with: "\"")
                        let json = JSON.init(parseJSON: validjson)
                        let abslist = json["abslist"]
                        let songs = abslist.arrayValue.map({
                            Song.init(
                                name: $0["SONGNAME"].stringValue.replacenbsp(),
                                album: $0["ALBUM"].stringValue.replacenbsp(),
                                artist: $0["ARTIST"].stringValue.replacenbsp(),
                                id: $0["MUSICRID"].stringValue)
                        })
                        completionhandler(songs)
                    }
                }
                
            }
        } else {
            print("invalid url")
            print(urlstring)
        }
        
    } else {
        return
    }
    
}

func KuwoSongURL(id: String, completionhandler: @escaping (String) -> Void) {
    if let url = "http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=\(id)&format=mp3&response=url"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        Alamofire.request(url).responseString { response in
            if let url = response.result.value,
                let resulturlstring = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                print("resultedurlstring")
                print(resulturlstring)
                completionhandler(resulturlstring)
            } else {
                print("invalid url")
            }
        }
    }
    
}

func download(_ url: URL, completionhandler: @escaping (Data) -> Void) {
    Alamofire.request(url)
        .responseData { (response) in
            if let data = response.result.value {
                completionhandler(data)
            }
        }
}




struct Song {
    let name: String
    let album: String
    let artist: String
    let id: String
    
    init(name: String, album: String, artist: String, id: String) {
        self.name = name
        self.album = album
        self.artist = artist
        self.id = id
    }
}

extension String {
    func replacenbsp() -> String {
        return self.replacingOccurrences(of: "&nbsp;", with: " ")
    }
}
