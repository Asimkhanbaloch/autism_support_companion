import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExercisePlans extends StatefulWidget {
  @override
  _ExercisePlansState createState() => _ExercisePlansState();
}

class _ExercisePlansState extends State<ExercisePlans> {
  final List<ExercisePlan> exercisePlans = [];
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      fetchExercisePlans();
    }
  }

  void fetchExercisePlans() async {
    final snapshot = await _firestore
        .collection('exercisePlans')
        .doc(user!.uid)
        .collection('plans')
        .get();

    setState(() {
      exercisePlans.clear();
      for (var doc in snapshot.docs) {
        exercisePlans.add(ExercisePlan(
          name: doc['name'],
          duration: doc['duration'],
          description: doc['description'],
          type: doc['type'],
        ));
      }
    });
  }

  void addExercisePlan() async {
    if (_exerciseController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      final newPlan = ExercisePlan(
        name: _exerciseController.text,
        duration: int.tryParse(_durationController.text) ?? 0,
        description: _descriptionController.text,
        type: _typeController.text,
      );

      await _firestore
          .collection('exercisePlans')
          .doc(user!.uid)
          .collection('plans')
          .add({
        'name': newPlan.name,
        'duration': newPlan.duration,
        'description': newPlan.description,
        'type': newPlan.type,
      });

      setState(() {
        exercisePlans.add(newPlan);
        _exerciseController.clear();
        _durationController.clear();
        _descriptionController.clear();
        _typeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _exerciseController,
              decoration: InputDecoration(
                labelText: 'Exercise Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Type (e.g., Cardio, Strength)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addExercisePlan,
              child: Text('Add Exercise Plan'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercisePlans.length,
                itemBuilder: (context, index) {
                  final plan = exercisePlans[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 4,
                    child: ListTile(
                      title: Text(plan.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Duration: ${plan.duration} minutes\nDescription: ${plan.description}\nType: ${plan.type}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExercisePlan {
  final String name;
  final int duration;
  final String description;
  final String type;

  ExercisePlan({
    required this.name,
    required this.duration,
    required this.description,
    required this.type,
  });
}
