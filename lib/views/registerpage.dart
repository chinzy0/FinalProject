import 'package:finalproject/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final _formKey = GlobalKey<FormState>();
final TextEditingController _email = TextEditingController();
final TextEditingController _password = TextEditingController();
final TextEditingController _name = TextEditingController();
final TextEditingController _tel = TextEditingController();
final TextEditingController _idline = TextEditingController();
List<String> categories = [
  'book',
  'clothes',
  'electrical',
  'furniture',
  'sport',
  'stationery',
];
String selectedCategory = categories[0];

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 320,
            child: ListView(
              children: [
                buildEmailInput(),
                buildPasswordInput(),
                buildNameInput(),
                buildTelInput(),
                buildIdlineInput(),
                buildCategoryDropdown(),
                SizedBox(
                  height: 20,
                ),
                buildSummitregister(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget buildTelInput() {
    return TextFormField(
      controller: _tel,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        icon: const Icon(Icons.phone),
        hintText: 'Tel',
        labelText: 'Tel',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget buildNameInput() {
    return TextFormField(
      controller: _name,
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

  Widget buildIdlineInput() {
    return TextFormField(
      controller: _idline,
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

  Widget buildEmailInput() {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: const Icon(Icons.email),
        hintText: 'Email',
        labelText: 'Email',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget buildPasswordInput() {
    return TextFormField(
      obscureText: true,
      controller: _password,
      decoration: const InputDecoration(
        icon: const Icon(Icons.password),
        hintText: 'Password',
        labelText: 'password',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in complete information.';
        }
        return null;
      },
    );
  }

  Widget buildCategoryDropdown() {
    return DropdownButtonFormField(
      value: selectedCategory,
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue.toString();
        });
      },
      decoration: const InputDecoration(
        icon: const Icon(Icons.favorite),
        labelText: 'Select the category of interest.',
      ),
    );
  }

  Widget buildSummitregister() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blue[900]),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          AuthService().signUpWithEmail(
            _email.text,
            _password.text,
            _name.text,
            _tel.text,
            _idline.text,
            selectedCategory,
            context,
          );
        }
        _navigateToLoginPageAndResetForm();
      },
      child: const Text("Submit"),
    );
  }

  void _navigateToLoginPageAndResetForm() {
    // Navigate back to the login page.
    Navigator.pop(context);

    // Reset the form fields by clearing the text controllers.
    _email.clear();
    _password.clear();
    _name.clear();
    _tel.clear();
    _idline.clear();
  }
}
