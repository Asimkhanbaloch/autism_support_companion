import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "A verification email has been sent to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                "Please check your inbox and verify your email.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}