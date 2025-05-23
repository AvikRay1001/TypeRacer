import 'package:flutter/material.dart';
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
      print(data);
    });
  }
}
