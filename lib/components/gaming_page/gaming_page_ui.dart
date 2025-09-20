import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';

class GamingPage extends StatefulWidget {
  final bool startTimerOnInit;
  const GamingPage({super.key, this.startTimerOnInit = false});

  @override
  State<GamingPage> createState() => _GamingPageState();
}

class _GamingPageState extends State<GamingPage> {
  final letters = "ASTRAGEN".split(""); // 8 letters
  int hiddenIndex = 0; // moves in background
  late Timer timer;
  final random = Random();

  Timer? _gameTimer;
  final int _totalSeconds = 30; // 5 minutes
  int _secondsLeft = 30;
  bool _showTimer = false;

  @override
  void initState() {
    super.initState();
    _startHiddenIndexTimer();
    if (widget.startTimerOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startGameTimer();
      });
    }
  }

  void _startHiddenIndexTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        hiddenIndex = random.nextInt(letters.length);
      });
    });
  }

  void _startGameTimer() {
    setState(() {
      _secondsLeft = _totalSeconds;
      _showTimer = true;
    });
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        t.cancel();
        _showTimeOverDialog();
      }
    });
  }

  void _stopGameTimer() {
    _gameTimer?.cancel();
    setState(() {
      _showTimer = false;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void _showTimeOverDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Time Over!"),
          content: const Text("Do you want to play again or go home?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGameTimer();
              },
              child: const Text("Play Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Home"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _handleTap(int index) {
    final isWinner = index == hiddenIndex;
    if (isWinner) {
      _gameTimer?.cancel();
      final int timeTaken = _totalSeconds - _secondsLeft;
      final String timeStr = _formatTime(timeTaken);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: const Text("🎉 Congratulations!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const Text("You found Jerry! Great job!"), const SizedBox(height: 12), Text("Time taken: $timeStr", style: const TextStyle(fontWeight: FontWeight.bold))],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startGameTimer();
                  },
                  child: const Text("Play Again"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Home"),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Better luck next time"), duration: Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            final shouldGoHome = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Exit Game'),
                    content: const Text('Are you sure you want to go home?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Home')),
                    ],
                  ),
            );
            if (shouldGoHome == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          icon: Icon(Icons.home),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Gaming Page"),
            if (_showTimer) ...[
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                child: Text(_formatTime(_secondsLeft), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
              ),
            ],
          ],
        ),
        actions: [if (!_showTimer) TextButton(onPressed: _startGameTimer, child: const Text("Play", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final size = MediaQuery.of(context).size;
          final isPortrait = orientation == Orientation.portrait;
          // Responsive sizes
          // Reduce card size and ensure fit
          final double boxSize = isPortrait ? (size.width - 80) / 3.2 : (size.width - 50) / 6.2;
          final double fontSize = boxSize / 2.8;
          final double underlineWidth = boxSize / 2.2;
          final double underlineHeight = 5;

          Widget gridOrWrap;
          if (isPortrait) {
            // Use Wrap for portrait
            gridOrWrap = Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(letters.length, (index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: boxSize,
                        height: boxSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4))],
                        ),
                        child: Text(letters[index], style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ),
                      SizedBox(height: 6),
                      Container(
                        width: underlineWidth,
                        height: underlineHeight,
                        decoration: BoxDecoration(color: hiddenIndex == index ? Colors.red : Colors.transparent, borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  ),
                );
              }),
            );
          } else {
            // Use GridView for landscape, center it and ensure it fits
            gridOrWrap = Center(
              child: SizedBox(
                width: size.width * 0.95,
                height: size.height * 0.8,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(letters.length, (index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: boxSize,
                            height: boxSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54, width: 2),
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4))],
                            ),
                            child: Text(letters[index], style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: underlineWidth,
                            height: underlineHeight,
                            decoration: BoxDecoration(color: hiddenIndex == index ? Colors.red : Colors.transparent, borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Padding(padding: const EdgeInsets.all(20.0), child: Center(child: gridOrWrap)),
          );
        },
      ),
    );
  }
}
