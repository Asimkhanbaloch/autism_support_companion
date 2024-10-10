import 'package:autism_support_companion/AccessibilitySettingsScreen.dart';
import 'package:autism_support_companion/dietary_guidance.dart';
import 'package:autism_support_companion/sleep_tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exercise_plans.dart';

class MoreFeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'More Features',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            buildGridItem(
              context,
              Icons.accessibility,
              'Accessibility Settings',
              Colors.lightGreen,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccessibilitySettingsScreen()),
                );
              },
            ),
            buildGridItem(
              context,
              Icons.fastfood,
              'Dietary Guidance',
              Colors.yellow,
                  () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DietaryGuideScreen()),);
              },
            ),
            buildGridItem(
              context,
              Icons.nights_stay,
              'Sleep Tracker',
              Colors.blue,
                  () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepTracker()),);
              },
            ),
            buildGridItem(
              context,
              Icons.fitness_center,
              'Exercise Plans',
              Colors.cyan,
                  () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExercisePlans()),);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
