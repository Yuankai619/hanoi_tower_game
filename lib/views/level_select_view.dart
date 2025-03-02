import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/game_view_model.dart';

class LevelSelectView extends StatelessWidget {
  const LevelSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'choose level',
          style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
        ),
      ),
      body: ListView.builder(
        itemCount: viewModel.maxLevel,
        itemBuilder: (context, index) {
          final level = index + 1;
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'level $level',
                  style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
                ),
                if (viewModel.currentLevel >= level &&
                    viewModel.moveRecord[level] > 0)
                  Text(
                    'least move count ${viewModel.moveRecord[level]}',
                    style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
                  ),
              ],
            ),
            enabled: level <= viewModel.unlockedLevels,
            onTap: () {
              viewModel.setLevel(level);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
