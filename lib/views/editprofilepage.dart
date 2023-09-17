import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfilePage({required this.userData, Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _telController = TextEditingController();
  TextEditingController _idlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['name'] ?? '';

    _telController.text = widget.userData['tel'] ?? '';
    _idlineController.text = widget.userData['idline'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        child: Form(
          child: SizedBox(
            child: ListView(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _telController,
                  decoration: InputDecoration(labelText: 'Telephone'),
                ),
                TextField(
                  controller: _idlineController,
                  decoration: InputDecoration(labelText: 'Line ID'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue[900]),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    _updateProfile();
                    // Return the updated user data to the previous page
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'tel': _telController.text,
                      'idline': _idlineController.text,
                    });
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _updateProfile() async {
    String name = _nameController.text;
    String tel = _telController.text;
    String idline = _idlineController.text;

    // Get the current user's UID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      return;
    }
    final uid = currentUser.uid;

    // Reference to the Firestore document of the current user
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    // Create a map with the fields you want to update
    Map<String, dynamic> updatedData = {
      'name': name,
      'tel': tel,
      'idline': idline,
    };

    try {
      // Update the user's data in Firestore directly
      await userDocRef.update(updatedData);
      // Data updated successfully, you can show a message or perform any additional actions
      print('User data updated successfully');
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error updating user data: $error');
      // You can also check the specific error code to determine the issue
      // For example, if the error code is 'not-found', it means the document doesn't exist.
    }
  }
}
