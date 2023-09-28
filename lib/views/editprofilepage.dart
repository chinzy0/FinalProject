import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/registerpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfilePage({required this.userData, Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _idlineController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['name'] ?? '';
    _telController.text = widget.userData['tel'] ?? '';
    _idlineController.text = widget.userData['idline'] ?? '';
    _loadCurrentCategory();
  }

  Future<String?> _fetchCurrentCategory() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return null;
    }
    final uid = currentUser.uid;
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    try {
      final userData = await userDocRef.get();
      if (userData.exists) {
        final category = userData.data()?['category'] as String?;
        return category;
      }
    } catch (error) {
      print('Error fetching category data: $error');
    }

    return null; // If no data found or error occurs
  }

  void _loadCurrentCategory() async {
    final currentCategory = await _fetchCurrentCategory();
    if (currentCategory != null) {
      setState(() {
        _selectedCategory = currentCategory;
      });
    }
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
          key: _formKey,
          child: SizedBox(
            child: ListView(
              children: [
                buildNameInput(),
                buildTelInput(),
                buildIdlineInput(),
                SizedBox(
                  height: 20,
                ),
                buildCategoryDropdown(),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[900]),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ตรวจสอบความถูกต้องของฟอร์ม
                      _updateProfile();
                      // Return the updated user data to the previous page
                      Navigator.pop(context, {
                        'name': _nameController.text,
                        'tel': _telController.text,
                        'idline': _idlineController.text,
                        'category': _selectedCategory,
                      });
                    }
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

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    final uid = currentUser.uid;
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    Map<String, dynamic> updatedData = {
      'name': name,
      'tel': tel,
      'idline': idline,
    };

    if (_selectedCategory != null) {
      updatedData['category'] = _selectedCategory;
    }

    try {
      await userDocRef.update(updatedData);
      print('User data updated successfully');
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  Widget buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Category'),
      value: _selectedCategory,
      items: [
        'book',
        'cloth',
        'electrical',
        'furniture',
        'sport',
        'stationery',
      ].map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget buildIdlineInput() {
    return TextFormField(
      controller: _idlineController,
      decoration: const InputDecoration(
        icon: const Icon(Icons.contacts),
        hintText: 'Line ID',
        labelText: 'Line ID',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget buildTelInput() {
    return TextFormField(
      controller: _telController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        icon: const Icon(Icons.phone),
        hintText: 'Tel',
        labelText: 'Tel',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        } else if (value.length != 10) {
          return 'Phone number must have exactly 10 digits.';
        }
        return null;
      },
    );
  }

  Widget buildNameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        icon: const Icon(Icons.person),
        hintText: 'Name',
        labelText: 'Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }
}
