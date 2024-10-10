import 'package:flutter/material.dart';

class CalmingExercisesScreen extends StatelessWidget {
  const CalmingExercisesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calming Exercises'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for animation
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.5),
              ),
              child: const Center(
                child: Text(
                  'Calming Animation Here',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Breathe in... and out...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to start calming animation
              },
              child: const Text('Start Calming Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
