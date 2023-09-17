import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signUpWithEmail(String email, String password, String name,
      String tel, String idline) async {
    try {
      // Create New User Account to Firebase Authen
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      print(uid);

      // Store User infomation (name, tel) to FireStore
      FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "email": email,
        "password": password,
        "name": name,
        "tel": tel,
        "idline": idline,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<int> loginUser(String email, String password) async {
    try {
      final Credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Successful");
      return 1;
    } on FirebaseAuthException catch (e) {
      print("Failed");
      print(e.code);

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return 2;
    } catch (e) {
      print(e);
    }
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
}
