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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesPage()),
                );
              }
            });
          }
        },
        child: const Text("Sing in"));
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
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Password";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
      ),
    );
  }
}
