import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/utils/socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('create-game', {'nickname': nickname});
    }
  }

  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider = Provider.of<GameStateProvider>(
        context, listen: false
      ).updateGameState(
        id: data['id'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
        words: data['words'],
      );

      if(data['_id'].isNotEmpty) {
        Navigator.pushNamed(context, '/game-screen');
      }


    });

  }
}
