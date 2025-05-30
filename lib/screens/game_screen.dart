import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/client_state_provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/widgets/game_text_field.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      body: Text('Game Screen'),
      bottomNavigationBar: const GameTextField(),
    );
  }
}
