import 'package:flutter/material.dart';

import 'components/home/home_ui.dart';
import 'components/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _videoPlayed = false;

  void _onVideoEnd() {
    setState(() {
      _videoPlayed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GameTheme.getThemeData(),
      title: "Tom & Jerry Game",
      home: _videoPlayed ? Scaffold(body: HomeUI()) : LocalVideoPlayer(onVideoEnd: _onVideoEnd),
    );
  }
}

class GameTheme {
  static ThemeData getThemeData() {
    const Color primaryColor = Color.fromARGB(255, 146, 255, 202);

    return ThemeData(brightness: Brightness.light, colorScheme: ColorScheme.light(primary: primaryColor));
  }
}
