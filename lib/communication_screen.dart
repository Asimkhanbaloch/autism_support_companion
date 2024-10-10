import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CommunicationScreen extends StatefulWidget {
  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final TextEditingController messageController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speech = SpeechToText();

  double textSize = 16.0;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> sendMessage(String message) async {
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  void startListening() async {
    await _speech.initialize();
    _speech.listen(onResult: (result) {
      setState(() {
        messageController.text = result.recognizedWords;
      });
    });
  }

  Future<void> speakMessage(String message) async {
    await flutterTts.speak(message);
  }

  Stream<QuerySnapshot> getMessages() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communication Hub'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index]['text'];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(
                          message,
                          style: TextStyle(fontSize: textSize, color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(messageController.text);
                  },
                ),
              ],
            ),
          ),
          Slider(
            min: 12,
            max: 24,
            value: textSize,
            onChanged: (newSize) {
              setState(() {
                textSize = newSize;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.mic),
                color: Colors.teal,
                onPressed: startListening,
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                color: Colors.teal,
                onPressed: () {
                  speakMessage(messageController.text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
