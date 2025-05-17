import 'package:flutter/material.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_text_field.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _namedcontroller = TextEditingController();
  @override
  void dispose() {
    _namedcontroller.dispose();
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
                const Text('Create Room', style: TextStyle(fontSize: 30)),
                SizedBox(height: size.height * 0.08),
                CustomTextField(
                  controller: _namedcontroller,
                  hintText: "Enter your nickname",
                ),
                const SizedBox(height: 30),
                CustomButton(text: 'Create', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
