import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/game_view_model.dart';

class GameOverView extends StatelessWidget {
  const GameOverView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Game over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations on completing all the levels!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.resetGame();
                Navigator.pop(context);
              },
              child: Text('restart all'),
            ),
          ],
        ),
      ),
    );
  }
}
