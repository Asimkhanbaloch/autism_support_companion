import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepTracker extends StatefulWidget {
  @override
  _SleepTrackerState createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  List<SleepRecord> sleepRecords = [];
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    fetchSleepRecords();
  }

  void fetchSleepRecords() async {
    if (user != null) {
      final snapshot = await _firestore
          .collection('sleepRecords')
          .doc(user!.uid)
          .collection('records')
          .get();

      setState(() {
        sleepRecords = snapshot.docs.map((doc) {
          final data = doc.data();
          return SleepRecord(
            sleepTime: TimeOfDay.fromDateTime(data['sleepTime'].toDate()),
            wakeTime: TimeOfDay.fromDateTime(data['wakeTime'].toDate()),
            duration: Duration(hours: data['duration'].inHours, minutes: data['duration'].inMinutes.remainder(60)),
          );
        }).toList();
      });
    }
  }

  void addSleepRecord() async {
    if (sleepTime != null && wakeTime != null) {
      final sleepDuration = Duration(
        hours: wakeTime!.hour - sleepTime!.hour,
        minutes: wakeTime!.minute - sleepTime!.minute,
      );

      final sleepRecord = {
        'sleepTime': DateTime.now().add(Duration(days: -1)).add(Duration(hours: sleepTime!.hour, minutes: sleepTime!.minute)),
        'wakeTime': DateTime.now().add(Duration(days: -1)).add(Duration(hours: wakeTime!.hour, minutes: wakeTime!.minute)),
        'duration': sleepDuration,
      };

      await _firestore
          .collection('sleepRecords')
          .doc(user!.uid)
          .collection('records')
          .add(sleepRecord);

      // Add to local list immediately
      setState(() {
        sleepRecords.add(SleepRecord(
          sleepTime: sleepTime!,
          wakeTime: wakeTime!,
          duration: sleepDuration,
        ));
        // Clear the input fields
        sleepTime = null;
        wakeTime = null;
      });
    }
  }

  void showTimePickerDialog(bool isSleepTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isSleepTime) {
          sleepTime = time;
        } else {
          wakeTime = time;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showTimePickerDialog(true),
              child: _buildCustomInputField('Sleep Time', sleepTime),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => showTimePickerDialog(false),
              child: _buildCustomInputField('Wake Time', wakeTime),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addSleepRecord,
              child: Text('Add Sleep Record'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sleepRecords.length,
                itemBuilder: (context, index) {
                  final record = sleepRecords[index];
                  return _buildRecordCard(record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomInputField(String label, TimeOfDay? time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          Text(
            time != null ? time.format(context) : 'Select Time',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(SleepRecord record) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep: ${record.sleepTime.format(context)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              'Wake: ${record.wakeTime.format(context)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              'Duration: ${record.duration.inHours}h ${record.duration.inMinutes.remainder(60)}m',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepRecord {
  final TimeOfDay sleepTime;
  final TimeOfDay wakeTime;
  final Duration duration;

  SleepRecord({required this.sleepTime, required this.wakeTime, required this.duration});
}
