//
//  MediaPlugin.m
//  Runner
//
//  Created by chihara on 2018/08/30.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "MediaPlugin.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FLTMediaPlugin ()<FlutterStreamHandler>
@end

@implementation FLTMediaPlugin {
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FLTMediaPlugin* instance = [[FLTMediaPlugin alloc] init];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.example.player/media" binaryMessenger:[registrar messenger]];
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSLog(@"handleMethodCall:%@", call.method);
    if ([@"getSongs" isEqualToString:call.method]) {
        NSMutableArray<NSMutableDictionary*>* list = [NSMutableArray<NSMutableDictionary*> array];
        MPMediaQuery* query = [MPMediaQuery songsQuery];
        NSArray* items = query.items;
        for (MPMediaItem* item in items) {
            NSMutableDictionary* dic = [NSMutableDictionary<NSString*, NSObject*> dictionary];
            dic[@"title"] = item.title;
            dic[@"artist"] = item.artist;
            dic[@"album"] = item.albumTitle;
            dic[@"albumArt"] = item.artwork;
            dic[@"track"] = [NSNumber numberWithInteger:item.albumTrackNumber];
            dic[@"duration"] = [NSNumber numberWithInteger:item.playbackDuration];
            [list addObject:dic];
        }
        result(list);
    }
    if ([@"getAlbums" isEqualToString:call.method]) {
        NSMutableArray<NSMutableDictionary*>* list = [NSMutableArray<NSMutableDictionary*> array];
        MPMediaQuery* query = [MPMediaQuery albumsQuery];
        NSArray* items = query.items;
        for (MPMediaItem* item in items) {
            NSMutableDictionary* dic = [NSMutableDictionary<NSString*, NSObject*> dictionary];
            dic[@"title"] = item.title;
            dic[@"artist"] = item.artist;
            dic[@"albumArt"] = item.artwork;
            dic[@"numOfTracks"] = [NSNumber numberWithInteger:item.albumTrackCount];
            [list addObject:dic];
        }
        result(list);
    }
}

@end
