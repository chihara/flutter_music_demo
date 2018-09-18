
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/model/song.dart';

class PlayingWidget extends StatefulWidget {

  final MethodChannel channel;
  final Song song;

  const PlayingWidget(this.channel, this.song, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayingWidget();
}

class _PlayingWidget extends State<PlayingWidget> {

  @override
  Widget build(BuildContext context) {
    if (null != widget.song) {
      return BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: Colors.black12,
                  height: 60.0,
                  width: 60.0,
                  child: _getAlbumArt(),
                ),
                Container(
                    color: Colors.transparent,
                    height: 60.0,
                    padding: EdgeInsets.only(left: 10.0, top: 6.0),
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              widget.song.title,
                              style: TextStyle(
                                  fontSize: 16.0
                              )
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  widget.song.elapsedInSeconds(),
                                  style: TextStyle(
                                      fontSize: 14.0
                                  )
                              ),
                              Slider(
                                  value: widget.song.elapsedAsPosition().toDouble(),
                                  onChanged: (double value) {
                                    Map params = <String, dynamic>{
                                      "position": value.toInt(),
                                    };
                                    widget.channel.invokeMethod("seek", params);
                                  },
                                  max: widget.song.duration.toDouble()
                              ),
                            ],
                          ),
                        ]
                    )
                )
              ]
          )
      );
    } else {
      return Container(
        height: 0.0,
      );
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