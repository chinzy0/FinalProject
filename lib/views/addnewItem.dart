import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddMoreNewItem extends StatefulWidget {
  const AddMoreNewItem({super.key});

  @override
  State<AddMoreNewItem> createState() => _AddMoreNewItemState();
}

class _AddMoreNewItemState extends State<AddMoreNewItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _detail = TextEditingController();

  String? selectedDocument;
  String? _imageUrl;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload Item",
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
                Categoryinput(),
                ItemNameinput(),
                Detailinput(),
                SizedBox(
                  height: 10,
                ),
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                  ),
                uploadImage(),
                SizedBox(
                  height: 10,
                ),
                Senddata()
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget ItemNameinput() {
    return TextFormField(
      controller: _itemname,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        icon: const Icon(Icons.person_3_rounded),
        hintText: 'Item Name',
        labelText: 'Item Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget Detailinput() {
    return TextFormField(
      controller: _detail,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        icon: const Icon(Icons.details),
        hintText: 'Detail',
        labelText: 'Detail',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget Categoryinput() {
    return Center(
      child: ListBody(
        children: [
          DropdownButton(
            hint:
                Text('Select Category'), // ข้อความที่แสดงเมื่อยังไม่เลือกเอกสาร
            value: selectedDocument,
            onChanged: (newValue) {
              setState(() {
                selectedDocument = newValue;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'book',
                child: Text('Book'),
              ),
              DropdownMenuItem(
                value: 'cloth',
                child: Text('Cloth'),
              ),
              DropdownMenuItem(
                value: 'electrical',
                child: Text('Electrical'),
              ),
              DropdownMenuItem(
                value: 'ferniture',
                child: Text('Ferniture'),
              ),
              DropdownMenuItem(
                value: 'sport',
                child: Text('Sport'),
              ),
              DropdownMenuItem(
                value: 'stationery',
                child: Text('Stationery'),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (selectedDocument == null)
            Text(
              'Please select a category',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget Senddata() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (_image == null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Warning'),
                  content: Text('Please upload an image.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            uploadItemData();
          }
        }
      },
      child: const Text("Submit"),
    );
  }

  Future<void> uploadItemData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? selectedValue = selectedDocument;
      if (selectedValue != null) {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('Items')
            .doc(selectedValue)
            .collection('dataItems')
            .doc();

        Map<String, dynamic> data = {
          'item_name': _itemname.text,
          'detail': _detail.text,
          'image_url': _imageUrl,
          'status': "available",
          'user_id': user.uid,
        };

        try {
          await documentReference.set(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoriesPage(),
            ),
          );
        } catch (error) {
          print('Error saving data: $error');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while saving the data.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Widget uploadImage() {
    return ElevatedButton(
      onPressed: _getImage,
      child: Text("Upload Image"),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // แสดงข้อความแจ้งเตือนเมื่อไม่มีรูปภาพถูกเลือก
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('No image selected.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // ไม่มีรูปภาพที่ถูกเลือก จึงออกจากเมธอด
    }

    final file = File(pickedFile.path);

    // ตรวจสอบว่ารูปภาพถูกเลือกและไม่ว่างเปล่า
    if (file.existsSync()) {
      // ตรวจสอบความสำเร็จของการอัปโหลด
      try {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('item_${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(file);

        final imageUrl = await storageRef.getDownloadURL();

        setState(() {
          _image = file;
          _imageUrl = imageUrl;
        });

        // แสดงข้อความแจ้งเตือนเมื่ออัปโหลดสำเร็จ
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Image uploaded successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        print('Error uploading image: $error');

        // แสดงข้อความแจ้งเตือนเมื่อเกิดข้อผิดพลาดในการอัปโหลด
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while uploading the image.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
