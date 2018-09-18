
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/model/album.dart';
import 'package:player/model/song.dart';
import 'package:player/ui/widget/song_item.dart';
import 'package:player/ui/widget/song_list.dart';

class AlbumScreen extends StatefulWidget {

  final Album album;

  AlbumScreen(this.album, { Key key }): super(key: key);

  @override
  State<StatefulWidget> createState() => _AlbumScreen();
}

class _AlbumScreen extends State<AlbumScreen> {

  final MethodChannel channel = const MethodChannel('com.example.player/media');

  List<Song> songs;

  @override
  void initState() {
    super.initState();
    if (null == songs || songs.isEmpty) {
      getSongs(albumId: widget.album.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                expandedHeight: 280.0,
                floating: false,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.file(
                        File(widget.album.albumArt),
                        fit: BoxFit.cover
                    )
                ),
                bottom: PreferredSize(
                    child: Container(
                      height: 80.0,
                      color: Colors.white,
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      widget.album.title,
                                      style: TextStyle(
                                          fontSize: 20.0
                                      )
                                  ),
                                  Text(
                                      widget.album.artist,
                                      style: TextStyle(
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            ),
                            Text(widget.album.durationInSeconds())
                          ]
                      ),
                    ),
                    preferredSize: Size.fromHeight(80.0)
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(top: 136.0),
          child: SongList(
              widget.album.songs,
              album: widget.album,
              onPressed: onSongPressed
          ),
        ),
      ),
    );
  }

  SongActionCallback onSongPressed(Song song) {
    Navigator.pop(context, song);
  }

  Future<dynamic> getSongs({int albumId}) async {
    var completer = Completer();
    Map params = <String, dynamic>{
      "albumId": albumId,
    };
    List<dynamic> songs = await channel.invokeMethod('getSongs', params);
    setState(() {
      widget.album.songs = songs.map((m) => Song.fromMap(m)).toList();
    });
    completer.complete(widget.album.songs);
    return completer.future;
  }
}
