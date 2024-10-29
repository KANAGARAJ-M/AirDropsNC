import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase Auth registration
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Save user data in Supabase
        final response = await _supabase
            .from('users')
            .insert({
              'email': emailController.text,
              'username': usernameController.text,
              'first_name': firstNameController.text,
              'last_name': lastNameController.text,
            });

        if (response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Supabase Error: ${response.error!.message}')));
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Firebase Auth Error: ${e.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextFormField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            TextFormField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
            ElevatedButton(onPressed: _registerUser, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
