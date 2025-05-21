import 'package:typeracer/utils/socket_client.dart';

class SocketMethods{
  final _socketClient = SocketClient.instance.socket!;

  createGame(String nickname){
    if(nickname.isNotEmpty){
      _socketClient.emit('create-game', {
        'nickname': nickname,
      });
    }
  }
}