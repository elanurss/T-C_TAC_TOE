import 'dart:ui';

class Game {
  String gameName;
  int gridSize;
  int bgColor;
  bool completed;

  Game(
      {required this.bgColor,
      required this.completed,
      required this.gameName,
      required this.gridSize});

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameName: map['gameName'],
      gridSize: map['gridSize'],
      bgColor: map['bgColor'],
      completed: map['completed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameName': gameName,
      'gridSize': gridSize,
      'bgColor': bgColor,
      'completed': completed,
    };
  }
}
