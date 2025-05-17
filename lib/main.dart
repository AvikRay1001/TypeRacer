import 'package:flutter/material.dart';
import 'package:typeracer/screens/create_screen.dart';
import 'package:typeracer/screens/home_screen.dart';
import 'package:typeracer/screens/join_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomeScreen(),
        '/create-room' : (context) => const CreateRoomScreen(),
        '/join-room' : (context) => const JoinRoomScreen(),
      }
    );
  }
}