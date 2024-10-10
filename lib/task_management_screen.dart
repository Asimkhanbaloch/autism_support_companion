import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskManagerScreen extends StatefulWidget {
  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _tasks = [];
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _taskDateController = TextEditingController();
  bool _isEditing = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      setState(() {
        _tasks = snapshot.docs;
      });
    });
  }

  Future<void> _addOrUpdateTask() async {
    if (_isEditing) {
      await _firestore.collection('tasks').doc(_editingId).update({
        'name': _taskNameController.text,
        'description': _taskDescriptionController.text,
        'date': _taskDateController.text,
      });
    } else {
      await _firestore.collection('tasks').add({
        'name': _taskNameController.text,
        'description': _taskDescriptionController.text,
        'date': _taskDateController.text,
      });
    }
    _clearFields();
  }

  void _clearFields() {
    _taskNameController.clear();
    _taskDescriptionController.clear();
    _taskDateController.clear();
    setState(() {
      _isEditing = false;
      _editingId = null;
    });
  }

  void _editTask(DocumentSnapshot task) {
    _taskNameController.text = task['name'];
    _taskDescriptionController.text = task['description'];
    _taskDateController.text = task['date'];
    setState(() {
      _isEditing = true;
      _editingId = task.id;
    });
  }

  Future<void> _deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_isEditing ? 'Edit Task' : 'Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskNameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              TextField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _taskDateController,
                decoration: InputDecoration(labelText: 'Date (e.g., 2024-09-30)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearFields();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _addOrUpdateTask().then((_) {
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal,
      ),
      body: _tasks.isEmpty
          ? Center(child: Text('No tasks available', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              title: Text(task['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${task['description']}\n${task['date']}', style: TextStyle(color: Colors.grey[700])),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editTask(task),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
