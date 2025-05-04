import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'game_over_page.dart';
import 'localization_provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final int rows = 10;
  final int cols = 20;
  List<Point> snake = [];
  Point food = Point(0, 0);
  Direction direction = Direction.right;
  Timer? timer;
  int score = 0;
  bool isPaused = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    snake = [
      Point(rows ~/ 2, cols ~/ 2),
      Point(rows ~/ 2, cols ~/ 2 - 1),
      Point(rows ~/ 2, cols ~/ 2 - 2),
    ];
    direction = Direction.right;
    score = 0;
    placeFood();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!isPaused) {
        moveSnake();
      }
    });
  }

  void placeFood() {
    food = Point(random.nextInt(rows), random.nextInt(cols));
  }

  void moveSnake() {
    Point head = snake.first;
    Point newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.down:
        newHead = Point(head.x + 1, head.y);
        break;
      case Direction.left:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.right:
        newHead = Point(head.x, head.y + 1);
        break;
    }

    if (newHead.x < 0 || newHead.x >= rows || newHead.y < 0 || newHead.y >= cols) {
      endGame();
      return;
    }

    if (snake.any((p) => p.x == newHead.x && p.y == newHead.y)) {
      endGame();
      return;
    }

    setState(() {
      snake.insert(0, newHead);
      if (newHead.x == food.x && newHead.y == food.y) {
        score += 10;
        placeFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void endGame() {
    timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverPage(
          score: score,
          onRestart: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GamePage()),
            );
          },
        ),
      ),
    );
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 && direction != Direction.up) {
            direction = Direction.down;
          } else if (details.delta.dy < 0 && direction != Direction.down) {
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0 && direction != Direction.left) {
            direction = Direction.right;
          } else if (details.delta.dx < 0 && direction != Direction.right) {
            direction = Direction.left;
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${loc.t('score')}: $score'),
                  Text('${loc.t('record')}: $score'), // В будущем: сохраняйте лучший результат
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  int row = index ~/ cols;
                  int col = index % cols;
                  bool isSnake = snake.any((p) => p.x == row && p.y == col);
                  bool isFood = food.x == row && food.y == col;

                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSnake
                          ? Colors.green
                          : isFood
                              ? Colors.red
                              : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePause,
        child: Icon(isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}

enum Direction { up, down, left, right }