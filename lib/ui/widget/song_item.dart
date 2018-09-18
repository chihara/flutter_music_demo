
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:player/model/album.dart';
import 'package:player/model/song.dart';

typedef void SongActionCallback(Song song);

class SongItem extends StatefulWidget {

  final Song song;
  final Album album;
  final SongActionCallback onPressed;

  SongItem(this.song, {this.album, this.onPressed}) : super (key: new ObjectKey(song));

  @override
  State<StatefulWidget> createState() => _SongItem();
}

class _SongItem extends State<SongItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (null == widget.onPressed ? null : () => widget.onPressed(widget.song)),
      child: ListTile(
        leading: _getLeading(),
        title: Text(widget.song.title),
        subtitle: _getSubtitle(),
        trailing: _getTrailing(),
      ),
    );
  }

  Widget _getLeading() {
    if (null != widget.album) {
      var track = widget.song.track % 1000;
      return Container(
        height: 45.0,
        width: 45.0,
        alignment: Alignment.center,
        child: Text(track.toString()),
      );
    } else {
      return Container(
        color: Colors.black12,
        height: 45.0,
        width: 45.0,
        child: _getAlbumArt(),
      );
    }
  }

  Widget _getSubtitle() {
    if (null != widget.album) {
      return null;
    } else {
      return Text(widget.song.durationInSeconds());
    }
  }

  Widget _getTrailing() {
    if (null != widget.album) {
      return Text(widget.song.durationInSeconds());
    } else {
      return Text(widget.song.artist);
    }
  }

  Widget _getAlbumArt() {
    if (widget.song.albumArt.isEmpty) {
      return FittedBox( // 子を領域の最大サイズに拡大
          fit: BoxFit.fill,
          child: Icon(Icons.music_note, color: Colors.white70)
      );
    } else {
      return Image.file(File(widget.song.albumArt), fit: BoxFit.cover);
    }
  }
}