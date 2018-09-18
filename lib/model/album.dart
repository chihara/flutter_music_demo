
import 'package:player/model/song.dart';

class Album {
  int id;
  String title;
  String artist;
  String albumArt;
  List<Song> songs;

  Album(this.id, this.title, this.artist, this.albumArt);

  Album.fromMap(Map m) {
    id = m["id"];
    title = m["title"];
    artist = m["artist"];
    albumArt = m["albumArt"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "artist": artist,
      "albumArt": albumArt,
    };
  }

  String durationInSeconds() {
    if (null == songs) {
      return "";
    } else {
      int duration = 0;
      for (var song in songs)
        duration = song.duration + duration;
      var text = Duration(milliseconds: duration)
          .toString()
          .split('.')
          .first;
      if (text.startsWith('0:'))
        text = text.substring(2, text.length);
      return text;
    }
  }
}