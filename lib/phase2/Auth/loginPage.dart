import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _supabase = Supabase.instance.client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _loginUser() async {
    try {
      // Firebase Auth login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Retrieve user data from Supabase
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', emailController.text);

      if (response == null && response.isNotEmpty) {
        // Successfully retrieved user data
        final userData = response[0];
        print('User data: $userData');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User not found in Supabase')));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Firebase Auth Error: ${e.message}')));
    }
  }

  Future<void> _resetPassword() async {
    if (emailController.text.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset link sent to your email')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enter your email to reset password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
          TextFormField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
          ElevatedButton(onPressed: _loginUser, child: Text('Login')),
          TextButton(onPressed: _resetPassword, child: Text('Forgot Password?'))
        ],
      ),
    );
  }
}
