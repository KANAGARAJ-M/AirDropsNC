
import 'package:air_drops/BottomNavScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay for 5 seconds and then navigate to the main screen
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          child: Image.asset('assets/logo.png')
        ),
      ),
    );
  }
}