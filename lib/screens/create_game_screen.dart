import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/game_model.dart';
import 'package:tic_tac_toe/services/firebase_service.dart';

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  _GameCreateScreenState createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  Color _selectedColor = Colors.white;
  int _selectedGridSize = 3;

  Future<void> _createGame() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a game name')),
      );
      return;
    }

    final newGame = Game(
      bgColor: _selectedColor.value,
      completed: false,
      gameName: _nameController.text,
      gridSize: _selectedGridSize,
    );

    await _firebaseService.createGame(newGame);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAE193),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Create Game',
        style: TextStyle(color: Color(0xFF4A4A4A)),
      ),
      backgroundColor: const Color(0xFFFAE193),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGameNameInput(),
            const SizedBox(height: 20),
            _buildGridSizeDropdown(),
            const SizedBox(height: 20),
            _buildColorSelectionRow(),
            const SizedBox(height: 40),
            _buildCreateGameButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameNameInput() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Game Name',
        labelStyle: const TextStyle(color: Color(0xFF6A0DAD)),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6A0DAD), width: 2.0),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      style: const TextStyle(color: Color(0xFF4A4A4A)),
    );
  }

  Widget _buildGridSizeDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Select Grid Size',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      value: _selectedGridSize,
      onChanged: (int? newSize) {
        setState(() {
          _selectedGridSize = newSize!;
        });
      },
      items: <int>[3, 4].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('${value}x$value'),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select Background Color:',
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        _buildColorDropdown(),
      ],
    );
  }

  Widget _buildColorDropdown() {
    return DropdownButton<Color>(
      value: _selectedColor,
      onChanged: (Color? newColor) {
        setState(() {
          _selectedColor = newColor!;
        });
      },
      items: <Color>[
        Colors.white,
        Colors.orange,
        Colors.green,
        Colors.red,
        Colors.pink
      ].map<DropdownMenuItem<Color>>((Color color) {
        return DropdownMenuItem<Color>(
          value: color,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    color == _selectedColor ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCreateGameButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton(
        onPressed: _createGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A0DAD),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text(
          'Create Game',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
