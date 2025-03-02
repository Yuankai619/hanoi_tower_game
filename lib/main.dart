import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/game_model.dart';
import 'models/tower.dart';
import 'view_models/game_view_model.dart';
import 'views/game_over_view.dart';
import 'views/game_view.dart';
import 'views/level_select_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create:
          (context) => GameViewModel(
            GameModel(
              towers: [
                Tower('A', [1, 2]), // 起始關卡 n = 2
                Tower('B', []),
                Tower('C', []),
              ],
              currentLevel: 2,
              moveCount: 0,
              maxLevel: 10,
              random: Random(),
              unlockedLevels: 2,
              shuffleCount: 0,
              isShuffling: false,
              isShowLevelComplete: false,
            ),
          ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower of Hanoi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/game',
      routes: {
        '/game': (context) => GameView(),
        '/level_select': (context) => LevelSelectView(),
        '/game_over': (context) => GameOverView(),
      },
    );
  }
}
