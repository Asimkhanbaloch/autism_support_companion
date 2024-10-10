import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SensoryFriendlyContentScreen extends StatelessWidget {
  SensoryFriendlyContentScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> videos = [
    {'title': 'Exercise 1', 'url': 'https://youtu.be/e0bzfqrMN2w'},
    {'title': 'Exercise 2', 'url': 'https://youtu.be/dhxY6MAIA_M'},
    {'title': 'Exercise 3', 'url': 'https://youtu.be/iWowDC3x0hE'},
    {'title': 'Exercise 4', 'url': 'https://youtu.be/BDYd2qFR45o'},
    {'title': 'Exercise 5', 'url': 'https://youtu.be/aEIpC4e2aBY'},
    {'title': 'Exercise 6', 'url': 'https://youtu.be/F2XVfTzel8E'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensory-friendly Content'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final videoId = videos[index]['url']!.split('/').last;
          final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.network(
                thumbnailUrl,
                width: 100,
                height: 75,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    width: 100,
                    height: 75,
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
              title: Text(
                videos[index]['title']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              trailing: const Icon(Icons.play_arrow, color: Colors.teal),
              onTap: () {
                _launchURL(videos[index]['url']!);
              },
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
