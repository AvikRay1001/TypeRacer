import 'package:flutter/material.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _namedcontroller = TextEditingController();
  final TextEditingController _gameIdcontroller = TextEditingController();
  

  @override
  void dispose() {
    _namedcontroller.dispose();
    _gameIdcontroller.dispose();
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
                  controller: _namedcontroller,
                  hintText: "Enter Game ID",
                ),
                const SizedBox(height: 30),
                CustomButton(text: 'Join', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}