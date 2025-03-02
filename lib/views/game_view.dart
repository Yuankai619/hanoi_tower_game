import 'package:flutter/material.dart';
import 'package:hanoi_tower/views/widgets/alert_dialog.dart';
import 'package:hanoi_tower/views/widgets/tower_widget.dart';
import 'package:provider/provider.dart';

import '../view_models/game_view_model.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hanoi Tower Hell',
          style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, '/level_select'),
          ),
        ],
      ),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.currentLevel == viewModel.maxLevel &&
              viewModel.isShowLevelComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/game_over');
            });
          } else if (viewModel.isShowLevelComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false, // 防止點擊外部關閉
                builder: (context) => AlertDialogWidget(viewModel: viewModel),
              );
            });
          }

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'level: ${viewModel.currentLevel}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoMono-SemiBold",
                          ),
                        ),
                        Text(
                          'move count: ${viewModel.moveCount}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoMono-SemiBold",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            viewModel.towers.map((tower) {
                              return TowerWidget(tower: tower);
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              if (viewModel.isShuffling)
                Positioned(
                  top: 180,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '🔄 Tower swap！',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontFamily: "RobotoMono-SemiBold",
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
