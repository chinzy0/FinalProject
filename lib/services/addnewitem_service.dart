import 'package:cloud_firestore/cloud_firestore.dart';

class Additem {
  Future<void> AddBook(String itemname, String detail) async {
    try {
      final collection = FirebaseFirestore.instance
          .collection('Items')
          .doc('book')
          .collection('DataBook');

      await collection.doc().set({
        "itemname": itemname,
        "detail": detail,
        "image": '',
        "uploadtime": '',
        "acepttime": '',
      });

      print('sent successfully');
    } catch (e) {
      print('Error when sending feedback');
    }
  }
}
