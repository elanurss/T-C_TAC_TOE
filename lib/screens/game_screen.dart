import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/constant.dart';
import 'package:tic_tac_toe/models/game_model.dart';
import 'package:tic_tac_toe/utils/config.dart';
import 'package:tic_tac_toe/widgets/button.dart';
import 'package:tic_tac_toe/widgets/cubes.dart';
import 'package:tic_tac_toe/widgets/scoreboard.dart';

class GameScreen extends StatefulWidget {
  final Game game;
  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> data = [];
  int xScore = 0;
  int oScore = 0;
  String currentPlayer = 'X';
  bool gameEnded = false;
  String winner = '';

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    data = List.generate(widget.game.gridSize,
        (_) => List.generate(widget.game.gridSize, (_) => ''));
    _chooseRandomPlayer();
    gameEnded = false;
    winner = '';
  }

  void _chooseRandomPlayer() {
    currentPlayer = _random.nextBool() ? 'X' : 'O';
  }

  void _onUserClick(int i, int j) {
    if (gameEnded || data[i][j] != '') {
      return;
    }

    setState(() {
      data[i][j] = currentPlayer;

      if (_checkForWinner()) {
        winner = currentPlayer;
        _endGame(winner);
        return;
      }

      if (_checkForTie()) {
        _endGame('Tie');
        return;
      }

      _switchPlayer();
    });
  }

  void _switchPlayer() {
    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
  }

  bool _checkForWinner() {
    return _checkRows() || _checkColumns() || _checkDiagonals();
  }

  bool _checkRows() {
    for (int row = 0; row < widget.game.gridSize; row++) {
      if (_checkRow(row)) return true;
    }
    return false;
  }

  bool _checkRow(int row) {
    String firstElement = data[row][0];
    if (firstElement == '') return false;

    for (int col = 1; col < widget.game.gridSize; col++) {
      if (data[row][col] != firstElement) return false;
    }
    return true;
  }

  bool _checkColumns() {
    for (int col = 0; col < widget.game.gridSize; col++) {
      if (_checkColumn(col)) return true;
    }
    return false;
  }

  bool _checkColumn(int col) {
    String firstElement = data[0][col];
    if (firstElement == '') return false;

    for (int row = 1; row < widget.game.gridSize; row++) {
      if (data[row][col] != firstElement) return false;
    }
    return true;
  }

  bool _checkDiagonals() {
    return _checkPrimaryDiagonal() || _checkSecondaryDiagonal();
  }

  bool _checkPrimaryDiagonal() {
    String firstElement = data[0][0];
    if (firstElement == '') return false;

    for (int i = 1; i < widget.game.gridSize; i++) {
      if (data[i][i] != firstElement) return false;
    }
    return true;
  }

  bool _checkSecondaryDiagonal() {
    String firstElement = data[0][widget.game.gridSize - 1];
    if (firstElement == '') return false;

    for (int i = 1; i < widget.game.gridSize; i++) {
      if (data[i][widget.game.gridSize - i - 1] != firstElement) return false;
    }
    return true;
  }

  bool _checkForTie() {
    for (var row in data) {
      if (row.contains('')) return false;
    }
    return true;
  }

  void _endGame(String result) {
    setState(() {
      gameEnded = true;
      winner = result;
      _updateScore(result);
      _showResultDialog(result);
    });
  }

  void _updateScore(String winner) {
    if (winner == 'X') {
      xScore++;
    } else if (winner == 'O') {
      oScore++;
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(result == 'Tie' ? 'It\'s a Tie!' : 'Player $result Wins!'),
          content:
              Image.asset("assets/images/winner.png", width: 150, height: 150),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetBoard() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _initializeData();
      });
    });
  }

  void _onNewGameClick() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _initializeData();
    });
  }

  void _onResetClick() {
    _resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAE193),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 3),
                child: ScoreboardWidget(
                  xScore: xScore,
                  yScore: oScore,
                ),
              ),
              ..._buildGameBoard(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 2),
                child: ButtonWidget(
                  onPressed: _onNewGameClick,
                  text: Constants.newGameText,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                child: ButtonWidget(
                  onPressed: _onResetClick,
                  text: Constants.resetGameText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGameBoard() {
    return List.generate(widget.game.gridSize, (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.game.gridSize, (j) {
          return GestureDetector(
            onTap: () {
              _onUserClick(i, j);
            },
            child: CubesWidget(
              i: i,
              j: j,
              displayElement: data[i][j],
              bgColor: widget.game.bgColor,
            ),
          );
        }),
      );
    });
  }
}
