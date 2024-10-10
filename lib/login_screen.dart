import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = e.message ?? 'An error occurred';
      }
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please login to your account',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('Login', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password logic
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('or login with', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialIconButton(Icons.facebook, Colors.blue, () {
                    // Handle Facebook login
                  }),
                  _socialIconButton(Icons.g_translate, Colors.red, () {
                    // Handle Google login
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.tealAccent, width: 2),
        ),
      ),
    );
  }

  Widget _socialIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 30),
    );
  }
}
