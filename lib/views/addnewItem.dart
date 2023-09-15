import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/category.dart';
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
        backgroundColor: MaterialStatePropertyAll(Colors.blue[900]),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          String? selectedValue = selectedDocument; // รับค่าจาก Dropdown
          if (selectedValue != null) {
            // สร้าง reference ไปยัง document ที่เลือก
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('Items')
                .doc(selectedValue)
                .collection('dataItems')
                .doc();

            // สร้างข้อมูลที่คุณต้องการบันทึก
            Map<String, dynamic> data = {
              'item_name': _itemname.text,
              'detail': _detail.text,
              'image_url': _imageUrl, // เพิ่ม URL ของรูปภาพ
            };

            // บันทึกข้อมูลลง Firebase Firestore
            documentReference.set(data).then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesPage(),
                ),
              );
            }).catchError((error) {
              // หากเกิดข้อผิดพลาดในการบันทึกข้อมูล
              print('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $error');
            });
          }
        }
      },
      child: const Text("Submit"),
    );
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

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // อัปโหลดรูปภาพไปยัง Firebase Storage
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
      } catch (error) {
        print('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: $error');
      }
    }
  }
}
