//
//  Song.swift
//  Runner
//
//  Created by 千原　寛之 on 2018/09/05.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import Foundation
import MediaPlayer

struct Song {
    let id: UInt64
    let title: String
    let artist: String
    let album: String
    let albumArt: String
    let track: Int
    let duration: UInt64
    
    func toDic() -> NSDictionary {
        let dic = NSMutableDictionary()
        dic["id"] = id
        dic["title"] = title
        dic["artist"] = artist
        dic["album"] = album
        dic["albumArt"] = albumArt
        dic["track"] = track
        dic["duration"] = duration
        return dic
    }
    
    static func fromMediaItem(item: MPMediaItem) -> Song {
        return Song(
            id: item.persistentID,
            title: item.title ?? "",
            artist: item.artist ?? "",
            album: item.albumTitle ?? "",
            albumArt: "",
            track: item.albumTrackNumber,
            duration: UInt64(item.playbackDuration))
    }
    
    static func fromDic(dic: NSDictionary) -> Song {
        return Song(
            id: <#T##UInt64#>,
            title: <#T##String#>,
            artist: <#T##String#>,
            album: <#T##String#>,
            albumArt: <#T##String#>,
            track: <#T##Int#>,
            duration: <#T##UInt64#>)
    }
}
