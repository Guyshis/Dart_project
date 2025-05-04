import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization_provider.dart';

class GameOverPage extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverPage({required this.score, required this.onRestart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              loc.t('game_over'),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('${loc.t('your_score')} $score'),
            const SizedBox(height: 40),
            ElevatedButton(
              child: Text(loc.t('play_again')),
              onPressed: onRestart,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(loc.t('to_menu')),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
