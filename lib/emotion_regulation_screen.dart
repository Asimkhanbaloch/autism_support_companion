import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionRegulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emotion Regulation"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How Are You Feeling?",
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              _buildEmotionButton(context, "Happy", Colors.yellow, _happySuggestions),
              _buildEmotionButton(context, "Sad", Colors.blue, _sadSuggestions),
              _buildEmotionButton(context, "Angry", Colors.red, _angrySuggestions),
              _buildEmotionButton(context, "Anxious", Colors.orange, _anxiousSuggestions),
              _buildEmotionButton(context, "Calm", Colors.green, _calmSuggestions),
              SizedBox(height: 30),
              Text(
                "Coping Strategies",
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              _buildCopingStrategy(context, "Deep Breathing"),
              _buildCopingStrategy(context, "Counting to 10"),
              _buildCopingStrategy(context, "Take a Break"),
              _buildCopingStrategy(context, "Talk to Someone"),
              SizedBox(height: 30),
              Text(
                "Calming Techniques",
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              _buildCalmingTechnique(context, "Listen to Music"),
              _buildCalmingTechnique(context, "Go for a Walk"),
              _buildCalmingTechnique(context, "Use a Stress Ball"),
              _buildCalmingTechnique(context, "Mindfulness Exercise"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionButton(BuildContext context, String emotion, Color color, List<String> suggestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          _showSuggestionsDialog(context, emotion, suggestions);
        },
        child: Text(
          emotion,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _showSuggestionsDialog(BuildContext context, String emotion, List<String> suggestions) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnimatedDialog(
          title: "$emotion Suggestions",
          suggestions: suggestions,
        );
      },
    );
  }

  List<String> _happySuggestions = [
    "Share your happiness with someone.",
    "Listen to your favorite music.",
    "Go for a fun activity.",
    "Practice gratitude.",
  ];

  List<String> _sadSuggestions = [
    "Talk to someone about your feelings.",
    "Write in a journal.",
    "Watch a favorite movie.",
    "Engage in a relaxing activity.",
  ];

  List<String> _angrySuggestions = [
    "Take deep breaths.",
    "Count to 10.",
    "Take a break from the situation.",
    "Talk about your feelings calmly.",
  ];

  List<String> _anxiousSuggestions = [
    "Practice mindfulness or meditation.",
    "Go for a walk.",
    "Talk to someone you trust.",
    "Try a grounding exercise.",
  ];

  List<String> _calmSuggestions = [
    "Maintain your calm by breathing deeply.",
    "Engage in a hobby.",
    "Practice yoga or stretching.",
    "Spend time in nature.",
  ];

  Widget _buildCopingStrategy(BuildContext context, String strategy) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(strategy, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CopingStrategyDetail(strategy: strategy),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalmingTechnique(BuildContext context, String technique) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(technique, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalmingTechniqueDetail(technique: technique),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedDialog extends StatelessWidget {
  final String title;
  final List<String> suggestions;

  const AnimatedDialog({Key? key, required this.title, required this.suggestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20),
            ...suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  suggestion,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

// Coping Strategy Detail Screen
class CopingStrategyDetail extends StatelessWidget {
  final String strategy;

  const CopingStrategyDetail({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String details = "";
    switch (strategy) {
      case "Deep Breathing":
        details = "Deep breathing helps to calm the mind and body. Inhale deeply through your nose, hold for a few seconds, then exhale slowly through your mouth.";
        break;
      case "Counting to 10":
        details = "When feeling overwhelmed, count to 10 slowly. This gives you a moment to pause and collect your thoughts.";
        break;
      case "Take a Break":
        details = "Step away from the situation. Go for a short walk or find a quiet space to recharge.";
        break;
      case "Talk to Someone":
        details = "Sharing your thoughts with a friend or family member can provide relief and new perspectives.";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strategy),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                details,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Calming Technique Detail Screen
class CalmingTechniqueDetail extends StatelessWidget {
  final String technique;

  const CalmingTechniqueDetail({Key? key, required this.technique}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String details = "";
    switch (technique) {
      case "Listen to Music":
        details = "Listening to your favorite music can lift your mood and help you relax. Create a calming playlist.";
        break;
      case "Go for a Walk":
        details = "Walking outside can clear your mind and reduce stress. Pay attention to your surroundings.";
        break;
      case "Use a Stress Ball":
        details = "Squeezing a stress ball can help relieve tension in your hands and provide a calming effect.";
        break;
      case "Mindfulness Exercise":
        details = "Engage in a mindfulness exercise like focusing on your breath or observing your surroundings to bring yourself to the present moment.";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(technique),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                details,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
