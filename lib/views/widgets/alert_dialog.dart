import 'package:flutter/material.dart';
import 'package:hanoi_tower/view_models/game_view_model.dart';

class AlertDialogWidget extends StatelessWidget {
  final GameViewModel viewModel;
  const AlertDialogWidget({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Finish!',
        style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
      ),
      content: Text(
        'move count: ${viewModel.moveCount}',
        style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            viewModel.resetGame();
            viewModel.isShowLevelComplete = false;
            Navigator.of(context).pop();
          },
          child: Text(
            'restart',
            style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
        ),
        TextButton(
          onPressed: () {
            viewModel.isShowLevelComplete = false;
            Navigator.of(context).pop();
            viewModel.nextLevel();
          },
          child: Text(
            'next level',
            style: TextStyle(fontFamily: "RobotoMono-SemiBold"),
          ),
        ),
      ],
    );
  }
}
