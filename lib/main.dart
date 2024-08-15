import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDefault();
  runApp(const TicTacToeApp());
}

/// Firebase initialize
Future<void> initializeDefault() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Center(),
    );
  }
}
