import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _relationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'relation': _relationController.text.trim(),
          'email': _emailController.text.trim(),
        });

        await userCredential.user!.sendEmailVerification();

        Navigator.pushReplacementNamed(context, '/verify-email');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _nameController,
                    label: "Full Name",
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _relationController,
                    label: "Relation with Patient",
                    icon: Icons.family_restroom,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your relation with the patient';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: "Email Address",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      child: Text("Register"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.teal, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.teal),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.tealAccent, width: 2),
          ),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
