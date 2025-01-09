import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:flutter/material.dart';

class RankinghomePage extends StatefulWidget {
  const RankinghomePage({super.key});

  @override
  State<RankinghomePage> createState() => _RankinghomePageState();
}

class _RankinghomePageState extends State<RankinghomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
        backgroundColor: Uicolor.appBar,
      ),
      backgroundColor: Uicolor.body,
      body: const Center(
        child: Text(
          'Ranking Page,\nComing Soon!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
