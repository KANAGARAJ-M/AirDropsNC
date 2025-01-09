
import 'package:air_drops/phase1/auth/auth_page.dart';
import 'package:air_drops/phase1/colors/UiColors.dart';
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
      backgroundColor: Uicolor.splash_logo_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/logo/aic_logo_500px_teal.png')
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              'By',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/logo/nc_logo_no_bg.png')
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}