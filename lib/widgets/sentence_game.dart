import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    return Padding;
  }
}
