import 'package:flutter/material.dart';

class AddedItemPage extends StatelessWidget {
  final String itemName;
  final String detail;
  final String imageUrl;

  AddedItemPage({
    required this.itemName,
    required this.detail,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(itemName, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              'Detail:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(detail, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Image.network(imageUrl), // แสดงรูปภาพจาก URL
          ],
        ),
      ),
    );
  }
}
