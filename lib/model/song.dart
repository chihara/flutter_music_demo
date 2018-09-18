
class Song {
  int id;
  String title;
  String artist;
  String album;
  String albumArt;
  int track;
  int duration;
  String data;
  int elapsed;

  Song(this.id, this.title, this.artist, this.album, this.albumArt,
      this.track, this.duration, this.data);

  Song.fromMap(Map m) {
    id = m["id"];
    title = m["title"];
    artist = m["artist"];
    album = m["album"];
    albumArt = m["albumArt"];
    track = m["track"];
    duration = m["duration"];
    data = m["data"];
    elapsed = m["elapsed"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "artist": artist,
      "album": album,
      "albumArt": albumArt,
      "track": track,
      "duration": duration,
      "data": data,
    };
  }

  String durationInSeconds() {
    var text = Duration(milliseconds: duration).toString().split('.').first;
    if (text.startsWith('0:'))
      text = text.substring(2, text.length);
    return text;
  }

  String elapsedInSeconds() {
    var text = Duration(milliseconds: elapsed).toString().split('.').first;
    if (text.startsWith('0:'))
      text = text.substring(2, text.length);
    return text;
  }

  int elapsedAsPosition() {
    if (elapsed > duration)
      return duration;
    return elapsed;
  }
}