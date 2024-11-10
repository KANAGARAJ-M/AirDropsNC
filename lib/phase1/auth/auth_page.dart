import 'package:air_drops/phase1/BottomNavScreen.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _countryController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _refCode = TextEditingController();
  
  bool isLogin = true;
  bool _isPasswordVisible = false; // Manage password visibility

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    if (AuthService().currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  void toggleFormMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void handleLoginRegister() async {
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        var userInfo = await AuthService().loginWithEmailOrUsername(
          _usernameController.text.trim().isEmpty
              ? _emailController.text.trim()
              : _usernameController.text.trim(),
          _passwordController.text.trim(),
          _refCode.text.trim(),
        );
        if (userInfo == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed, please register first.')),
          );
          toggleFormMode();
        } else {
          checkUser();
        }
      } else {
        // Check if email is already registered
        bool isEmailRegistered = await AuthService().isEmailAlreadyRegistered(_emailController.text.trim());
        if (isEmailRegistered) {
          _showEmailAlreadyRegisteredPopup(); // Show popup if email is already registered
        } else {
          var userInfo = await AuthService().registerWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _countryController.text.trim(),
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _refCode.text.trim(),
          );
          if (userInfo != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful.')),
            );
            toggleFormMode();
          }
        }
      }
    }
  }

  void _showEmailAlreadyRegisteredPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Already Registered'),
          content: const Text(
              'The email address you provided is already registered. Please log in or use a different email address to register.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!isLogin) ...[
                    _buildTextField(_firstNameController, 'First Name', isMandatory: true),
                    _buildTextField(_lastNameController, 'Last Name', isMandatory: true),
                    _buildTextField(_countryController, 'Country', isMandatory: true),
                    _buildTextField(_refCode, 'Referral Code', isMandatory: true),
                  ],
                  _buildTextField(_emailController, 'Email', isMandatory: true),
                  _buildTextField(
                    _passwordController,
                    'Password',
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    isMandatory: true,
                    validatePassword: true, // Add password validation
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: handleLoginRegister,
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: toggleFormMode,
                    child: Text(
                      isLogin ? 'Create an account' : 'Have an account? Log in',
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, bool isPasswordVisible = false, VoidCallback? togglePasswordVisibility, bool isMandatory = false, bool validatePassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible, // Toggle password visibility
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.teal,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
        ),
        validator: (value) {
          if (isMandatory && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          if (validatePassword && value!.length < 8) {
            return 'Password must be at least 8 characters long';
          }
          return null;
        },
      ),
    );
  }
}
