
import 'package:flutter/material.dart';
import 'package:player/model/album.dart';
import 'package:player/ui/widget/album_item.dart';


class AlbumList extends StatefulWidget {

  final AlbumActionCallback onPressed;
  final List<Album> albums;

  AlbumList(this.albums, {Key key, this.onPressed}): super(key: key);

  @override
  State<StatefulWidget> createState() => _AlbumList();
}

class _AlbumList extends State<AlbumList> {

  @override
  Widget build(BuildContext context) {
    if (null == widget.albums) {
      return Center(
          child: CircularProgressIndicator()
      );
    } else if (widget.albums.isEmpty) {
      return Center(
          child: Text('音楽データがありません'),
      );
    } else {
      return _getListView();
    }
  }

  Widget _getListView() {
    return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: EdgeInsets.all(4.0),
        children: widget.albums.map((Album album) {
          return AlbumItem(
              album,
              onPressed: widget.onPressed
          );
        }).toList()
    );
  }
}