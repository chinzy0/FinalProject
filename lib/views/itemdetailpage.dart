import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  ItemDetailsPage({required this.item});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Access the item data using widget.item
    var item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Item Name: ${item['item_name']}'),
          Text('Item Description: ${item['detail']}'),
          // Add more details as needed
        ],
      ),
    );
  }
}
