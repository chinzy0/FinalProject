import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UploadHistoryPage extends StatefulWidget {
  const UploadHistoryPage({super.key});

  @override
  State<UploadHistoryPage> createState() => _UploadHistoryPageState();
}

class _UploadHistoryPageState extends State<UploadHistoryPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "History",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .doc('book')
            .collection('dataItems')
            .where('user_id', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text(
                'No items available',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          var items = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              var itemName = item['item_name'];
              var itemDescription = item['detail'];
              var imageUrl = item['image_url'];
              var itemStatus = item['status'];

              return ListTile(
                title: Text(itemName),
                subtitle: Text(itemDescription),
                leading: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
                trailing: Text(itemStatus),
                // แสดงข้อมูลเพิ่มเติมตามความต้องการ
              );
            },
          );
        },
      ),
    );
  }
}
