import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<void> signUpWithEmail(
      String email,
      String password,
      String name,
      String tel,
      String idline,
      String selectedCategory,
      BuildContext context) async {
    try {
      // Create New User Account to Firebase Authen
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      print(uid);

      // Store User information (name, tel) to Firestore
      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "email": email,
        "password": password,
        "name": name,
        "tel": tel,
        "idline": idline,
        'category': selectedCategory,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Show a Snackbar for weak password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // Show a Snackbar for email already in use
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<int> loginUser(String email, String password) async {
    try {
      // Authenticate the user using Firebase Authentication
      final Credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user's credentials match the admin credentials
      if (email == 'admin@gmail.com' && password == '123456') {
        // Set a custom login status for the admin user
        // You can use a shared preference or global state management to store this status
        // For this example, we'll print a message
        print("Admin user logged in.");
        return 3; // Custom status code for admin login
      }

      // For non-admin users, return a different status code (e.g., 1 for successful login)
      print("Successful login for a non-admin user.");
      return 1;
    } on FirebaseAuthException catch (e) {
      print("Failed");
      print(e.code);

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      // Return a status code for authentication failure
      return 2; // Custom status code for authentication failure
    } catch (e) {
      print(e);
    }

    // Return a default status code (e.g., 0 for other errors)
    return 0;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        // Return an empty map when no user data is found
        return {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle the error as needed, you might choose to throw an exception or return a specific error map
      return {}; // Return an empty map in case of error
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      // Password reset email sent successfully
    } catch (e) {
      // Handle errors here
      print('Error sending password reset email: $e');
    }
  }
}
