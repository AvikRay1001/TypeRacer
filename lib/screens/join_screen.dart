import 'package:flutter/material.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _namedcontroller = TextEditingController();
  final TextEditingController _gameIDcontroller = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGameListener(context);
    _socketMethods.notCorrectGameListener(context);
  }

  @override
  void dispose() {
    _namedcontroller.dispose();
    _gameIDcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Join Room', style: TextStyle(fontSize: 30)),
                SizedBox(height: size.height * 0.08),
                CustomTextField(
                  controller: _namedcontroller,
                  hintText: "Enter your nickname",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _gameIDcontroller,
                  hintText: "Enter Game ID",
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Join',
                  onTap:
                      () => _socketMethods.joinGame(
                        _namedcontroller.text,
                        _gameIDcontroller.text,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
