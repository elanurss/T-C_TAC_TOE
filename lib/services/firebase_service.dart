// services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/models/game_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGame(Game game) async {
    // Create a new game document in Firestore
    DocumentReference docRef = await _firestore.collection('games').add({
      'gameName': game.gameName,
      'gridSize': game.gridSize,
      'bgColor': game.bgColor,
      'completed': false,
    });

    return docRef.id;
  }

  Stream<QuerySnapshot> getGames() {
    // Retrieve list of games in real-time
    // return _firestore.collection('games').orderBy('createdAt').snapshots();
    return _firestore.collection('games').snapshots();
  }

  Future<void> updateGame(String gameId, Map<String, dynamic> data) async {
    // Update specific game details
    await _firestore.collection('games').doc(gameId).update(data);
  }
}
