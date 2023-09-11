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
  final _selectedCategory = '';

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
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SizedBox(
            child: ListView(
              children: [],
            ),
          ),
        ),
      )),
    );
  }
}
