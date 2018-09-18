//
//  Album.swift
//  Runner
//
//  Created by 千原　寛之 on 2018/09/05.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import Foundation
import MediaPlayer

struct Album {
    let id: UInt64
    let title: String
    let artist: String
    let albumArt: String
    let numOfTracks: Int
    
    func toDic() -> NSDictionary {
        let dic = NSMutableDictionary()
        dic["id"] = id
        dic["title"] = title
        dic["artist"] = artist
        dic["albumArt"] = albumArt
        dic["numOfTracks"] = numOfTracks
        return dic
    }
    
    func fromMediaItem(item: MPMediaItem) -> Album {
        return Album(
            id: item.albumPersistentID,
            title: item.title ?? "",
            artist: item.artist ?? "",
            albumArt: "",
            numOfTracks: numOfTracks)
    }
}
