part of audio_player;

enum SongType { LOCAL, NETWORK }

class Song implements ISong {
  @override
  String name;
  @override
  String singer;
  @override
  String album;
  @override
  int duration;
  @override
  String source;
  SongType type;

  Song(this.source, this.type,
      {this.name, this.singer, this.album, this.duration});

  static Song fromString(String song) {
    var uri = Uri.parse(song);
    if (uri.isScheme('http')) {
      return Song(song, SongType.NETWORK);
    } else if (uri.isScheme('https')) {
      throw DataTypeInvalidException('Do not support https');
    }

    var file = File(song);
    if (file.existsSync()) {
      return Song(song, SongType.LOCAL);
    }

    throw NotFoundException(song);
  }
}
