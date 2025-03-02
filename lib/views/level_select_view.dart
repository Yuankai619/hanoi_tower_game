import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/game_view_model.dart';

class LevelSelectView extends StatelessWidget {
  const LevelSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('選擇關卡')),
      body: ListView.builder(
        itemCount: viewModel.maxLevel,
        itemBuilder: (context, index) {
          final level = index + 1;
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('關卡 $level'),
                if (viewModel.currentLevel >= level &&
                    viewModel.moveRecord[level] > 0)
                  Text('步數 ${viewModel.moveRecord[level]}'),
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
