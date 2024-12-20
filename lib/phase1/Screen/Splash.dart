
import 'package:air_drops/phase1/auth/auth_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 181, 255),
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset('assets/logo/aic_coin_512.png')
        ),
      ),
    );
  }
}