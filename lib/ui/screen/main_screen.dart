
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/model/album.dart';
import 'package:player/model/song.dart';
import 'package:player/ui/screen/album_screen.dart';
import 'package:player/ui/widget/album_item.dart';
import 'package:player/ui/widget/playing_widget.dart';
import 'package:player/ui/widget/song_list.dart';
import 'package:player/ui/widget/album_list.dart';
import 'package:player/ui/widget/song_item.dart';

class MainScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {

  final MethodChannel channel = const MethodChannel('com.example.player/media');

  List<Song> songs;
  List<Album> albums;
  Song song;
  bool playing;

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(handler);
    if (null == songs || songs.isEmpty) {
      getSongs();
    }
    if (null == albums || albums.isEmpty) {
      getAlbums();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: _getFAB(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: PlayingWidget(channel, song),
          appBar: AppBar(
            leading: Icon(Icons.sentiment_neutral),
            title: Text("Music Player Demo"),
            bottom: TabBar(
                unselectedLabelColor: Colors.white30,
                indicatorColor: Theme.of(context).accentIconTheme.color,
                tabs: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 4.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.music_note),
                            Text("songs")
                          ]
                      )
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 4.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.album),
                            Text("albums")
                          ]
                      )
                  )
                ]
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              SongList(songs, onPressed: onSongPressed),
              AlbumList(albums, onPressed: onAlbumPressed)
            ],
          ),
        )
    );
  }

  SongActionCallback onSongPressed(Song song) {
    channel.invokeMethod("play", song.toMap());
  }

  AlbumActionCallback onAlbumPressed(BuildContext context, Album album) {
    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => AlbumScreen(album))
    ).then((song) {
      if (null != song)
        channel.invokeMethod("play", song.toMap());
    });
  }

  Widget _getFAB() {
    if (null != song) {
      return playing ?
      FloatingActionButton(child: Icon(Icons.pause), onPressed: () {
        channel.invokeMethod("play", song.toMap());
      }) :
      FloatingActionButton(child: Icon(Icons.play_arrow), onPressed: () {
        channel.invokeMethod("play", song.toMap());
      });
    }
    return null;
  }

  Future<dynamic> getSongs() async {
    var completer = Completer();
    List<dynamic> list = await channel.invokeMethod('getSongs', null);
    if (null != list) {
      setState(() {
        songs = list.map((m) => Song.fromMap(m)).toList();
      });
      completer.complete(songs);
    }
    return completer.future;
  }

  Future<dynamic> getAlbums() async {
    var completer = Completer();
    List<dynamic> list = await channel.invokeMethod('getAlbums', null);
    if (null != list) {
      setState(() {
        albums = list.map((m) => Album.fromMap(m)).toList();
      });
      completer.complete(albums);
    }
    return completer.future;
  }

  Future handler(MethodCall call) async {
    switch (call.method) {
      case 'onPlay':
        setState(() {
          playing = true;
        });
        break;
      case 'onPause':
        setState(() {
          playing = false;
        });
        break;
      case 'onComplete':
        setState(() {
          song = null;
          playing = false;
        });
        break;
      case 'onPlaying':
        setState(() {
          song = Song.fromMap(call.arguments);
        });
        break;
      case 'onGranted':
        if (null == songs || songs.isEmpty) {
          getSongs();
        }
        if (null == albums || albums.isEmpty) {
          getAlbums();
        }
        break;
    }
  }
}