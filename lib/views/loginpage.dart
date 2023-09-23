import 'package:finalproject/services/admin/adminpage.dart';
import 'package:finalproject/services/auth_service.dart';
import 'package:finalproject/views/category.dart';

import 'package:finalproject/views/homepage.dart';
import 'package:finalproject/views/registerpage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _email = TextEditingController();
final _password = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _isPasswordVisible = false;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blue[900],
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(13),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: Column(
                            children: [
                              buildEmailInput(),
                              buildPasswordInput(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildEmailSignin(),
                        buildForgotPasswordButton(),
                        buildEmailSignup(),
                      ],
                    )),
              ),
            )));
  }

  Widget buildEmailSignup() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ));
            },
            child: const Text("Register now"),
          )
        ],
      ),
    );
  }

  Widget buildEmailSignin() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blue[900]),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          AuthService.loginUser(_email.text, _password.text).then((value) {
            if (value == 1) {
              _resetForm();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesPage(),
                ),
              );
            } else if (value == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login failed'),
                ),
              );
            }
          });
        }
      },
      child: const Text("Sing in"),
    );
  }

  TextFormField buildEmailInput() {
    return TextFormField(
      controller: _email,
      decoration: const InputDecoration(labelText: "E-mail"),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Email";
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordInput() {
    return TextFormField(
      controller: _password,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Password";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          child: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        if (_email.text.isNotEmpty) {
          // ตรวจสอบว่าช่องอีเมลไม่ว่างเปล่า
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Forgot Password"),
                content: Text("Enter your email to reset your password."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      try {
                        await AuthService().sendPasswordResetEmail(_email.text);
                        Navigator.of(context).pop();
                      } catch (e) {
                        // Handle the error, e.g., show an error message to the user.
                        print("Password reset failed: $e");
                      }
                    },
                    child: Text("Reset Password"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              );
            },
          );
        } else {
          // แสดงข้อความของคุณเมื่อช่องอีเมลว่างเปล่า
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter your email to reset the password.'),
            ),
          );
        }
      },
      child: Text("Forgot Password?"),
    );
  }

  void _resetForm() {
    _email.clear();
    _password.clear();
  }
}
