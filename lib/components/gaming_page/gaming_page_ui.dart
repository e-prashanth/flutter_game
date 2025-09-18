import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GamingPage extends StatefulWidget {
  const GamingPage({super.key});

  @override
  _GamingPageState createState() => _GamingPageState();
}

class _GamingPageState extends State<GamingPage> {
  final letters = "ASTRAGEN".split(""); // 8 letters
  int hiddenIndex = 0; // moves in background
  late Timer timer;
  final random = Random();

  @override
  void initState() {
    super.initState();

    // keep moving hidden red highlight every second
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        hiddenIndex = random.nextInt(letters.length);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _handleTap(int index) {
    final isWinner = index == hiddenIndex;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isWinner ? "🎉 Win!" : "Better luck next time"), duration: const Duration(milliseconds: 500)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(letters.length, (index) {
            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black54, width: 2), color: Colors.transparent),
                    child: Text(letters[index], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  // Small red line for testing (only visible at hiddenIndex)
                  Container(width: 40, height: 5, color: hiddenIndex == index ? Colors.red : Colors.transparent),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
