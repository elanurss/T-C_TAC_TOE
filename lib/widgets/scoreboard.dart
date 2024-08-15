import 'package:flutter/material.dart';

class ScoreboardWidget extends StatelessWidget {
  final int xScore;
  final int yScore;

  const ScoreboardWidget({
    super.key,
    required this.xScore,
    required this.yScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScoreColumn(
          "Player X",
          xScore,
          const Color(0xFF4A4A4A),
        ),
        const SizedBox(width: 40),
        _buildScoreColumn(
          "Player O",
          yScore,
          const Color(0xFF4A4A4A),
        ),
      ],
    );
  }

  Widget _buildScoreColumn(String playerName, int score, Color color) {
    return Column(
      children: [
        Text(
          playerName,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 21,
            color: color,
          ),
        ),
      ],
    );
  }
}
