import 'package:cloud_firestore/cloud_firestore.dart';

class Additem {
  Future<void> Add(String itemname, String detail) async {
    try {
      final collection = FirebaseFirestore.instance.collection('Items');

      await collection.doc().set({
        "itemname": itemname,
        "detail": detail,
      });

      print('Feedback sent successfully');
    } catch (e) {
      print('Error when sending feedback');
    }
  }
}
