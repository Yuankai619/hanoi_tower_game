import 'dart:math';
import 'tower.dart';

class GameModel {
  List<Tower> towers;
  int currentLevel;
  int moveCount;
  int maxLevel;
  Random random;
  int unlockedLevels;
  int shuffleCount;

  GameModel({
    required this.towers,
    required this.currentLevel,
    required this.moveCount,
    required this.maxLevel,
    required this.random,
    required this.unlockedLevels,
    required this.shuffleCount,
  });

  void moveDisk(String from, String to) {
    var fromTower = towers.firstWhere((tower) => tower.name == from);
    var toTower = towers.firstWhere((tower) => tower.name == to);
    print("fromTower: ${fromTower.disks}, ToTower: ${toTower.disks}");
    if (fromTower.disks.isNotEmpty &&
        (toTower.disks.isEmpty || fromTower.disks.first < toTower.disks.first)) {
      toTower.disks.insert(0,fromTower.disks.removeAt(0));
      moveCount++;
    }

  }

  bool isLevelComplete() {
    var targetTower = towers.firstWhere((tower) => tower.name == 'C');
    return targetTower.disks.length == currentLevel &&
        targetTower.disks.every((disk) => disk == targetTower.disks.indexOf(disk) + 1);
  }

  void nextLevel() {
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

  void shuffleTowers() {
    if (shuffleCount < 3) {
      towers.shuffle(random);
      shuffleCount++;
    }
  }

  void resetGame() {
    currentLevel = 2;
    unlockedLevels = 2;
    shuffleCount = 0;
    resetTowers();
  }
}
