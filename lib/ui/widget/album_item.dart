
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:player/model/album.dart';

typedef void AlbumActionCallback(BuildContext context, Album album);

class AlbumItem extends StatefulWidget {

  final Album album;
  final AlbumActionCallback onPressed;

  AlbumItem(this.album, {this.onPressed}) : super (key: new ObjectKey(album));

  @override
  State<StatefulWidget> createState() => _AlbumItem(album, onPressed: onPressed);
}

class _AlbumItem extends State<AlbumItem> {

  final Album album;
  final AlbumActionCallback onPressed;

  _AlbumItem(this.album, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: Stack( // 子を重ねて表示
            children: <Widget>[
              Positioned.fill( // 子を領域の最大サイズに拡大
                child: _getAlbumArt(),
              ),
              Align( // 子を指定alignmentの位置に配置
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 40.0,
                      color: Colors.black54,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                      album.title,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white
                                      )
                                  ),
                                  Text(
                                      album.artist,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white
                                      )
                                  )
                                ]
                            )
                          ]
                      )
                  )
              ),
              Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                      onTap: (null == onPressed ? null : () => onPressed(context, album))
                  )
              )
            ]
        ),
      ),
    );
//    return Card(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(6.0))
//        ),
//        child: Stack( // 子を重ねて表示
//            children: <Widget>[
//              Positioned.fill( // 子を領域の最大サイズに拡大
//                child: _getAlbumArt(),
//              ),
//              Align( // 子を指定alignmentの位置に配置
//                  alignment: Alignment.bottomCenter,
//                  child: Container(
//                      height: 40.0,
//                      color: Colors.black54,
//                      child: Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Column(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  Text(
//                                      album.title,
//                                      style: TextStyle(
//                                          fontSize: 16.0,
//                                          color: Colors.white
//                                      )
//                                  ),
//                                  Text(
//                                      album.artist,
//                                      style: TextStyle(
//                                          fontSize: 12.0,
//                                          color: Colors.white
//                                      )
//                                  )
//                                ]
//                            )
//                          ]
//                      )
//                  )
//              ),
//              Material(
//                  type: MaterialType.transparency,
//                  child: InkWell(
//                      onTap: (null == onPressed ? null : () => onPressed(context, album))
//                  )
//              )
//            ]
//        )
//    );
  }

  Widget _getAlbumArt() {
    if (album.albumArt.isEmpty) {
      return FittedBox(
          fit: BoxFit.fill,
          child: Icon(Icons.music_note, color: Colors.black12)
      );
    } else {
      return Image.file(File(album.albumArt), fit: BoxFit.cover);
    }
  }
}