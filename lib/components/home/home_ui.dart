import 'package:flutter/material.dart';

import '../gaming_page/gaming_page_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: OrientationBuilder(
            builder: (context, orientation) {
              return _landingPage(orientation);
            },
          ),
        ),
      ),
    );
  }

  Widget _landingPage(Orientation orientation) {
    final isPortrait = orientation == Orientation.portrait;
    final children = <Widget>[
      Text("Help me to find Jerry!", style: Theme.of(context).textTheme.headlineLarge),
      Icon(Icons.person, size: 250),
      ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GamingPage(startTimerOnInit: true))), child: Text("Play")),
    ];
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait ? Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: children) : Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
      ),
    );
  }
}
