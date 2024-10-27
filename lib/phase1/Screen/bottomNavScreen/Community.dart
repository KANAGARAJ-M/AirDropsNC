import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        backgroundColor: Uicolor.appBar,
        title: const Text('Community - Coming Soon!..'),
      ),
      body: const Center(
        child: Text("Coming Soon...",style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
      ),
    );
  }
}