//
//  MediaPlugin.swift
//  Runner
//
//  Created by 千原　寛之 on 2018/09/03.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import Foundation
import MediaPlayer
import Flutter

public class MediaPlugin: NSObject, FlutterPlugin {
    
    private let player = MPMusicPlayerController.applicationMusicPlayer
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        print("register")
        let channel = FlutterMethodChannel(
            name: "com.example.player/media",
            binaryMessenger: registrar.messenger()
        )
        let instance = MediaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        debugPrint("handle:%s", call.method)
        switch call.method {
        case "getSongs":
            let list = NSMutableArray.init()
//            let items = MPMediaQuery.songs().items
//            for item in items! {
//                let dic = NSMutableDictionary()
//                dic["id"] = item.persistentID
//                dic["title"] = item.title
//                dic["artist"] = item.artist
//                dic["album"] = item.albumTitle
//                dic["albumArt"] = item.artwork
//                dic["track"] = item.albumTrackNumber
//                dic["duration"] = item.playbackDuration
//                list.add(dic)
//            }
            createDummySongs(list: list)
            result(list)
        case "getAlbums":
            let list = NSMutableArray.init()
//            let items = MPMediaQuery.albums().items
//            for item in items! {
//                let dic = NSMutableDictionary()
//                dic["id"] = item.albumPersistentID
//                dic["title"] = item.title
//                dic["artist"] = item.artist
//                dic["albumArt"] = item.artwork
//                dic["numOfTracks"] = item.albumTrackCount
//                list.add(dic)
//            }
            createDummyAlbums(list: list)
            result(list)
        case "play":
            if (MPMusicPlaybackState.playing == player.playbackState) {
                player.pause()
            } else {
                let song = Song.fromDic(dic: call.arguments as! NSDictionary)
                let query = MPMediaQuery.songs()
                query.addFilterPredicate(MPMediaPropertyPredicate(value: song.id, forProperty: MPMediaItemPropertyPersistentID))
                player.setQueue(with: query)
                player.play()
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func createDummySongs(list: NSMutableArray) {
        for num in 1...25 {
            let song = Song(
                id: 0,
                title: "item.title\(num)",
                artist: "item.artist\(num)",
                album: "item.albumTitle\(num)",
                albumArt: "",
                track: num,
                duration: UInt64(100000 * num))
            list.add(song.toDic())
        }
    }
    
    private func createDummyAlbums(list: NSMutableArray) {
        for num in 1...11 {
            let album = Album(
                id: 0,
                title: "item.title\(num)",
                artist: "item.artist\(num)",
                albumArt: "",
                numOfTracks: num)
            list.add(album.toDic())
        }
    }
}
