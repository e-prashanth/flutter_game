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
              return Center(child: _landingPage());
            },
          ),
        ),
      ),
    );
  }

  Widget _landingPage() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Help me to find Jerry!", style: Theme.of(context).textTheme.headlineLarge),
            Icon(Icons.person, size: 350),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GamingPage())), child: Text("Play")),
          ],
        ),
      ),
    );
  }
}
