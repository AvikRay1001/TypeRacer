import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/client_state_provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/utils/socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('create-game', {'nickname': nickname});
    }
  }

  joinGame(String nickname, String gameID) {
    if (nickname.isNotEmpty && gameID.isNotEmpty) {
      _socketClient.emit('join-game', {'nickname': nickname, 'gameID': gameID});
    }
  }

  sendUserInput(String value, String gameID) {
    print("Hello");
    _socketClient.emit('userInput', {'userInput': value, 'gameID': gameID});
  }

  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider = Provider.of<GameStateProvider>(
        context,
        listen: false,
      ).updateGameState(
        id: data['_id'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
        words: data['words'],
      );

      if (data['_id'].isNotEmpty && !_isPlaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isPlaying = true;
      }
    });
  }

  startTimer(playerId, gameID) {
    _socketClient.emit('timer', {'playerId': playerId, 'gameID': gameID});
  }

  notCorrectGameListener(BuildContext context) {
    _socketClient.on(
      'notCorrectGame',
      (data) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data))),
    );
  }

  updateTimer(BuildContext context) {
    final clientStateProvider = Provider.of<ClientStateProvider>(
      context,
      listen: false,
    );
    print('hello from updateTimer');
    _socketClient.on('timer', (data) {
      clientStateProvider.setClientState(data);
    });
  }

  updateGame(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider = Provider.of<GameStateProvider>(
        context,
        listen: false,
      ).updateGameState(
        id: data['_id'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
        words: data['words'],
      );
    });
  }

  gameFinishedListener() {
    _socketClient.on('done', (data) => _socketClient.off('timer'));
  }
}
