import 'package:finalproject/services/addnewitem_service.dart';
import 'package:finalproject/views/category.dart';
import 'package:flutter/material.dart';

class AddMoreNewItem extends StatefulWidget {
  const AddMoreNewItem({super.key});

  @override
  State<AddMoreNewItem> createState() => _AddMoreNewItemState();
}

class _AddMoreNewItemState extends State<AddMoreNewItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _detail = TextEditingController();

  List<String> dropdownItems = [
    'Book',
    'Cloth',
    'Electrical',
    'Ferniture',
    'Sport',
    'Stationery'
  ];
  String selectedValue = 'Book';

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
          return 'กรุณากรอกข้อมูลให้ครบ';
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
          return 'กรุณากรอกข้อมูลให้ครบ';
        }
        return null;
      },
    );
  }

  Widget Categoryinput() {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: (newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      items: dropdownItems.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Category',
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
            Additem()
                .AddBook(
                  _itemname.text,
                  _detail.text,
                )
                .then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriesPage())));
          }
        },
        child: const Text("ยืนยัน"));
  }
}
