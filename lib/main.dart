import 'package:flutter/material.dart';
import 'package:guitare_video_calls/video_calls_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Video Call',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VideoCallScreen(),
    );
  }
}