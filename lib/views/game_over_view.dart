import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';

class GameOverView extends StatelessWidget {
  const GameOverView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('遊戲結束')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('恭喜你完成所有關卡！', style: TextStyle(fontSize: 24)),
            Text('總步數: ${viewModel.moveCount}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.resetGame();
                Navigator.pop(context);
              },
              child: Text('重新開始'),
            ),
          ],
        ),
      ),
    );
  }
}
