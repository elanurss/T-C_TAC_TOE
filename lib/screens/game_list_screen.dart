import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/screens/create_game_screen.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import '../services/firebase_service.dart';
import '../models/game_model.dart';

class GameListScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAE193),
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildGameList(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFFAE193),
      title: const Text(
        'Game List',
        style: TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 5,
      backgroundColor: const Color(0xFF6A0DAD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: () => _navigateToCreateGame(context),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _navigateToCreateGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameCreateScreen()),
    );
  }

  Widget _buildGameList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getGames(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final games = snapshot.data!.docs.map((doc) {
          return Game.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        return games.isEmpty ? _buildEmptyState() : _buildGameListView(games);
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No games available.',
        style: TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildGameListView(List<Game> games) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        return _buildGameListItem(context, games[index]);
      },
    );
  }

  Widget _buildGameListItem(BuildContext context, Game game) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () => _navigateToGameScreen(context, game),
        child: _buildGameContainer(game),
      ),
    );
  }

  Container _buildGameContainer(Game game) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20.0),
        title: Text(
          game.gameName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          'Grid Size: ${game.gridSize}x${game.gridSize}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.black54,
          size: 28,
        ),
      ),
    );
  }

  void _navigateToGameScreen(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(game: game)),
    );
  }
}
