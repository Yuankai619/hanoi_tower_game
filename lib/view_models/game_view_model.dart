import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../models/tower.dart';

class GameViewModel extends ChangeNotifier {
  final GameModel _gameModel;

  GameViewModel(this._gameModel);

  List<Tower> get towers => _gameModel.towers;
  int get currentLevel => _gameModel.currentLevel;
  int get moveCount => _gameModel.moveCount;
  int get maxLevel => _gameModel.maxLevel;
  int get unlockedLevels => _gameModel.unlockedLevels;
  int get shuffleCount => _gameModel.shuffleCount;

  void moveDisk(String from, String to) {
    _gameModel.moveDisk(from, to);
    if (_gameModel.isLevelComplete()) {
      if (_gameModel.currentLevel == _gameModel.maxLevel) {
        Future.delayed(Duration(milliseconds: 500), () {
          navigateToGameOver();
        });
      } else {
        _gameModel.nextLevel();
      }
    }
    // else if (_gameModel.shuffleCount < 3 &&
    //     _gameModel.random.nextInt(10) == 0) {
    //   _gameModel.shuffleTowers();
    //   notifyListeners();
    //   Future.delayed(Duration(seconds: 2), () {
    //     notifyListeners();
    //   });
    // }
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
