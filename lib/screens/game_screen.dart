import 'package:flutter/material.dart';
import 'package:typeracer/widgets/game_text_field.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Game Screen'),
      bottomNavigationBar: const GameTextField(),
    );
  }
}
