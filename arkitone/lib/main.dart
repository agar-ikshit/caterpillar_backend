import 'package:arkitone/ar_screen.dart';
import 'package:arkitone/arpage.dart';
import 'package:arkitone/clientpage.dart';
import 'package:arkitone/health.dart';
import 'package:arkitone/homelander.dart';
import 'package:arkitone/homepage.dart';
import 'package:arkitone/login.dart';
import 'package:arkitone/start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Recognition Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),  
      home: homepage(),
    );
  }
}