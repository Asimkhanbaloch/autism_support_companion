import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  UserProfileScreen({required this.userId});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String gender = 'Male';
  String? profilePictureUrl;
  bool isEditing = false;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        nameController.text = userData['name'] ?? '';
        ageController.text = (userData['age'] ?? '').toString();
        bloodGroupController.text = userData['bloodGroup'] ?? '';
        gender = userData['gender'] ?? 'Male';
        profilePictureUrl = userData['profilePictureUrl'];
      } else {
        // Handle case where user does not exist
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      // Handle any errors during fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching user data: $e')));
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetch
      });
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': nameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'bloodGroup': bloodGroupController.text,
        'gender': gender,
        'profilePictureUrl': profilePictureUrl,
      });
      setState(() {
        isEditing = false; // Exit editing mode after saving
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Upload logic for image should be implemented here
      setState(() {
        profilePictureUrl = image.path; // Replace with actual URL after upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('User Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.teal,
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true; // Enter editing mode
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profilePictureUrl != null ? NetworkImage(profilePictureUrl!) : null,
                  child: profilePictureUrl == null ? Icon(Icons.camera_alt, size: 60, color: Colors.white) : null,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, 'Name', Icons.person, isEditing),
              SizedBox(height: 16),
              _buildTextField(ageController, 'Age', Icons.calendar_today, isEditing, keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildTextField(bloodGroupController, 'Blood Group', Icons.bloodtype, isEditing),
              SizedBox(height: 16),
              _buildGenderDropdown(isEditing),
              SizedBox(height: 20),
              if (isEditing)
                ElevatedButton(
                  onPressed: _updateUserProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Save Changes'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool enabled, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.teal[50],
      ),
    );
  }

  Widget _buildGenderDropdown(bool enabled) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.teal[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: gender,
          isExpanded: true,
          onChanged: enabled ? (String? newValue) {
            setState(() {
              gender = newValue!;
            });
          } : null,
          items: <String>['Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
