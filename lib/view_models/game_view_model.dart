import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/game_model.dart';
import '../models/tower.dart';

class GameViewModel extends ChangeNotifier {
  final GameModel _gameModel;

  GameViewModel(this._gameModel);

  List<Tower> get towers => _gameModel.towers;
  List<int> get moveRecord => _gameModel.moveRecord;
  int get currentLevel => _gameModel.currentLevel;
  int get moveCount => _gameModel.moveCount;
  int get maxLevel => _gameModel.maxLevel;
  int get unlockedLevels => _gameModel.unlockedLevels;
  int get shuffleCount => _gameModel.shuffleCount;
  bool get isShuffling => _gameModel.isShuffling;
  bool get isShowLevelComplete => _gameModel.isShowLevelComplete;

  set isShowLevelComplete(bool state) => _gameModel.isShowLevelComplete = state;

  void nextLevel() async {
    _gameModel.nextLevel();
    notifyListeners();
  }

  Future<void> moveDisk(String from, String to) async {
    _gameModel.moveDisk(from, to);
    final player = AudioPlayer();
    await player.play(AssetSource('audios/fast-simple-chop.mp3'));
    if (_gameModel.isLevelComplete()) {
      final player = AudioPlayer();
      await player.play(AssetSource('audios/level-up.mp3'));
      _gameModel.isShowLevelComplete = true;
      if (_gameModel.currentLevel == _gameModel.maxLevel) {
        navigateToGameOver();
        notifyListeners();
      } else {}
    } else if (_gameModel.shuffleCount < 3 &&
        _gameModel.random.nextInt(5) == 0) {
      _gameModel.isShuffling = true;
      _gameModel.shuffleTowers();
      notifyListeners();
      Future.delayed(Duration(seconds: 2), () {
        _gameModel.isShuffling = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void setLevel(int level) {
    if (level <= unlockedLevels) {
      _gameModel.currentLevel = level;
      _gameModel.resetTowers();
      notifyListeners();
    }
  }

  void resetGame() {
    _gameModel.resetGame();
    notifyListeners();
  }

  void navigateToGameOver() {}
}
