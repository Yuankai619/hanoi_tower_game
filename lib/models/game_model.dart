import 'dart:math';

import 'tower.dart';

class GameModel {
  List<Tower> towers;
  List<int> moveRecord;
  int currentLevel;
  int moveCount;
  int maxLevel;
  Random random;
  int unlockedLevels;
  int shuffleCount;
  bool isShuffling;
  bool isShowLevelComplete;
  GameModel({
    required this.towers,
    this.moveRecord = const [],
    required this.currentLevel,
    required this.moveCount,
    required this.maxLevel,
    required this.random,
    required this.unlockedLevels,
    required this.shuffleCount,
    required this.isShuffling,
    required this.isShowLevelComplete,
  }) {
    moveRecord = List.filled(maxLevel + 1, 0, growable: true);
  }

  void moveDisk(String from, String to) {
    var fromTower = towers.firstWhere((tower) => tower.name == from);
    var toTower = towers.firstWhere((tower) => tower.name == to);

    if (fromTower.disks.isNotEmpty &&
        (toTower.disks.isEmpty ||
            fromTower.disks.first < toTower.disks.first)) {
      toTower.disks.insert(0, fromTower.disks.removeAt(0));
      moveCount++;
    }
  }

  bool isLevelComplete() {
    var targetTower = towers.firstWhere((tower) => tower.name == 'C');
    return targetTower.disks.length == currentLevel &&
        targetTower.disks.every(
          (disk) => disk == targetTower.disks.indexOf(disk) + 1,
        );
  }

  void nextLevel() {
    moveRecord[currentLevel] =
        moveRecord[currentLevel] != 0
            ? min(moveCount, moveRecord[currentLevel])
            : moveCount;
    if (currentLevel < maxLevel) {
      currentLevel++;
      unlockedLevels =
          currentLevel > unlockedLevels ? currentLevel : unlockedLevels;
      resetTowers();
    }
  }

  void resetTowers() {
    towers = [
      Tower('A', List.generate(currentLevel, (index) => index + 1)),
      Tower('B', []),
      Tower('C', []),
    ];
    moveCount = 0;
  }

  bool _isSameOrder(List<Tower> original, List<Tower> shuffled) {
    for (int i = 0; i < original.length; i++) {
      if (original[i] != shuffled[i]) {
        return false;
      }
    }
    return true;
  }

  void shuffleTowers() {
    if (shuffleCount < 3) {
      List<Tower> originalOrder = List.from(towers); // 記錄原始順序

      do {
        towers.shuffle(random); // 重新排列
      } while (_isSameOrder(originalOrder, towers)); // 確保與原來不同

      shuffleCount++;
    }
  }

  void resetGame() {
    currentLevel = 2;
    unlockedLevels = 2;
    shuffleCount = 0;
    isShowLevelComplete = false;
    resetTowers();
  }
}
