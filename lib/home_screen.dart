import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Autism Support Companion',
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Providing the best support tools for individuals on the autism spectrum',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  buildGridItem(Icons.spa, 'Sensory Support', Colors.blue, context, '/sensory-support'),
                  buildGridItem(Icons.chat, 'Communication Tools', Colors.green, context, '/communication-tools'),
                  buildGridItem(Icons.checklist, 'Task Management', Colors.orange, context, '/task-manager'), // Navigation to Task Management
                  buildGridItem(Icons.emoji_emotions, 'Emotional Regulation', Colors.purple, context, '/emotional-regulation'),
                  buildGridItem(Icons.person, 'Profile', Colors.pink, context, '/profile'),
                  buildGridItem(Icons.more_horiz, 'More Features', Colors.red, context, '/more-features'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Implement logout functionality
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.logout, color: Colors.white),
      ),
    );
  }

  Widget buildGridItem(IconData icon, String title, Color color, BuildContext context, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
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
