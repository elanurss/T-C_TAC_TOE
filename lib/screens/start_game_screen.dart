import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/screens/game_list_screen.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName');
    if (name != null) {
      _navigateToGameList();
    }
  }

  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    _navigateToGameList();
  }

  void _navigateToGameList() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GameListScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (nameFocusNode.hasFocus) {
          nameFocusNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFAE193),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildSubmitButton(),
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      child: ElevatedButton(
        onPressed: _onSubmitPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color(0xFF6A0DAD),
          shadowColor: Colors.black45,
        ),
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _onSubmitPressed() {
    if (_nameController.text.isNotEmpty) {
      _saveUsername();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a user name')),
      );
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFAE193),
      elevation: 0,
      title: const Text('TIC TAC TOE'),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6A0DAD),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tic-tac-toe.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.person,
          size: 30,
          color: Color(0xFF6A0DAD),
        ),
        const SizedBox(width: 5),
        Text(
          'Please enter your name to start:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6A0DAD),
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      focusNode: nameFocusNode,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: Color(0xFF6A0DAD)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6A0DAD), width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }
}
