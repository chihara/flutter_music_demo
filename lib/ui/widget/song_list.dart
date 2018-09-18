
import 'package:flutter/material.dart';
import 'package:player/model/album.dart';
import 'package:player/model/song.dart';
import 'package:player/ui/widget/song_item.dart';

class SongList extends StatefulWidget {

  final SongActionCallback onPressed;
  final List<Song> songs;
  final Album album;

  SongList(this.songs, {Key key, this.album, this.onPressed}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _SongList();
}

class _SongList extends State<SongList> {

  @override
  Widget build(BuildContext context) {
    if (null == widget.songs) {
      return Center(
          child: CircularProgressIndicator()
      );
    } else if (widget.songs.isEmpty) {
      return Center(
          child: Text('音楽データがありません'),
      );
    } else {
      return _getListView();
    }
  }

  Widget _getListView() {
    return ListView.builder(
        key: const ValueKey<String>('song-list'),
        itemBuilder: (BuildContext context, int index) {
          var length = widget.songs?.length ?? 0;
          if (length <= index) {
            return null;
          } else {
            return SongItem(
                widget.songs[index],
                album: widget.album,
                onPressed: widget.onPressed
            );
          }
        }
    );
  }
}