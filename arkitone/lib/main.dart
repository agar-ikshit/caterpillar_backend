import 'package:arkitone/ar_screen.dart';
import 'package:arkitone/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recognition Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceForm() ,
    );
  }
}