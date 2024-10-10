import 'package:flutter/material.dart';
import 'calming_exercise_screen.dart';
import 'sensory_friendly_content_screen.dart';

class SensorySupportScreen extends StatelessWidget {
  const SensorySupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensory Support'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.self_improvement, color: Colors.purple),
            title: Text('Calming Exercises'),
            subtitle: Text('Explore calming exercises for sensory support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalmingExercisesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_red_eye, color: Colors.blue),
            title: Text('Sensory-friendly Content'),
            subtitle: Text('Discover sensory-friendly content'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SensoryFriendlyContentScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
