part of audio_player;

class Player {
  List<ISong> _playlist;
  int _curSongIdx;
  IProcessPlayer _player;

  /// forbid new intance
  Player() {
    throw CannotInstantiateException(runtimeType.toString());
  }

  /// private method to new a instance
  Player._newInstance()
      : _playlist = [],
        _curSongIdx = 0;

  static Future<Player> run([IProcessPlayer processPlayer]) async {
    var player = Player._newInstance();
    player._player = processPlayer ?? Mpg123Player();
    await player._player._run();
    return player;
  }

  Player play([dynamic songs]) {
    addSong(songs);
    _player._play(_playlist.first);
    return this;
  }

  /// dont insert song into playlist
  Player playWithoutList(dynamic songs) {
    if (songs != null) {
      if (songs is String) {
        _player._play(Song.fromString(songs));
      } else if (songs is ISong) {
        _player._play(songs);
      } else {
        throw DataTypeInvalidException(songs.toString());
      }
    }
    return this;
  }

  Player addSong(dynamic songs) {
    if (songs != null) {
      if (songs is String) {
        _playlist.add(Song.fromString(songs));
      } else if (songs is ISong) {
        _playlist.add(songs);
      } else if (songs is List<ISong>) {
        _playlist.addAll(songs);
      } else if (songs is List<String>) {
        songs.forEach((song) => _playlist.add(Song.fromString(song)));
      } else {
        throw DataTypeInvalidException(songs.toString());
      }
    }
    return this;
  }

  Player pause() {
    _player._pause();
    return this;
  }

  Player resume() {
    _player._resume();
    return this;
  }

  Player next() {
    if (_curSongIdx >= _playlist.length - 1) {
      _curSongIdx = 0;
    } else {
      _curSongIdx++;
    }
    _player._play(_playlist[_curSongIdx]);
    return this;
  }

  Player pre() {
    if (_curSongIdx <= 0) {
      _curSongIdx = _playlist.length - 1;
    } else {
      _curSongIdx--;
    }
    _player._play(_playlist[_curSongIdx]);
    return this;
  }

  Player forward({int seconds = 5, int frame}) {
    if (seconds != null) {
      _player._jump(seconds: seconds, offset: true);
    } else if (frame != null) {
      _player._jump(frame: frame, offset: true);
    }
    return this;
  }

  Player back({int seconds = 5, int frame}) {
    if (seconds != null) {
      _player._jump(seconds: -seconds, offset: true);
    } else if (frame != null) {
      _player._jump(frame: -frame, offset: true);
    }
    return this;
  }

  Player upVolumne([int delta = 10]) {
    _player._upVolume(delta);
    return this;
  }

  Player downVolume([int delta = 10]) {
    _player._downVolume(delta);
    return this;
  }

  Player setSpeed([double speed = 0]) {
    _player._tuneSpeed(speed);
    return this;
  }

  void stop() => _player._stop();

  void quit() {
    _player._quit();
    exit(0);
  }

  Player listenMusicInfo(void Function(Map<String, String> musicInfo) listener) {
    _player._getMusicInfo().listen(listener);
    return this;
  }

  Player listenProgress(void Function(Map<String, double> progress) listener) {
    _player._getProgress().listen(listener);
    return this;
  }

  Player listenStatus(void Function(int status) listener) {
    _player._getStatus().listen(listener);
    return this;
  }

  Player listenError(void Function(String error) listener) {
    _player._getError().listen(listener);
    return this;
  }
}
