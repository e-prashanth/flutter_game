import 'package:flutter/material.dart';

import 'components/home/home_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GameTheme.getThemeData(), 
      title: "Tom & Jerry Game", 
      home: Scaffold( body: HomeUI()));
  }
}

class GameTheme{
  static ThemeData getThemeData(){
    const Color primaryColor = Color.fromARGB(255, 146, 255, 202);

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor
      )
    );
  }
}
