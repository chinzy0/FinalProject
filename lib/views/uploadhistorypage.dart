import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UploadHistoryPage extends StatefulWidget {
  const UploadHistoryPage({super.key});

  @override
  State<UploadHistoryPage> createState() => _UploadHistoryPageState();
}

class _UploadHistoryPageState extends State<UploadHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? currentUserId;
  String selectedDocument = 'book';

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
            color: Colors.black,
          ),
        ),
        actions: [
          // Place the dropdown in the AppBar's actions.
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedDocument = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'book',
                  child: Text('Book'),
                ),
                PopupMenuItem<String>(
                  value: 'cloth',
                  child: Text('Cloth'),
                ),
                // Add more items for other documents as needed.
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .doc(selectedDocument) // Use selected document here.
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

              // Define colors based on item status
              Color cardColor = itemStatus == 'Waiting for confirmation'
                  ? Colors.yellow
                  : itemStatus == 'Confirmed'
                      ? Colors.grey
                      : Colors.white; // Default card color

              return SizedBox(
                // Set the desired width
                height: 80, // Set the desired height
                child: Card(
                  elevation: 2,
                  color: cardColor,
                  child: ListTile(
                    title: Text(
                      itemName,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      itemDescription,
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showItemDetailsDialog(itemName, itemDescription,
                                imageUrl, itemStatus);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.all(8.0)), // Adjust button padding
                            minimumSize: MaterialStateProperty.all(
                                Size(80, 30)), // Adjust button minimum size
                          ),
                          child: Text(
                            "Given",
                            style: TextStyle(
                                fontSize: 12), // Adjust button text size
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(itemName, itemStatus);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.all(8.0)), // Adjust button padding
                            minimumSize: MaterialStateProperty.all(
                                Size(80, 30)), // Adjust button minimum size
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18), // Adjust icon size
                              SizedBox(
                                  width:
                                      4), // Add spacing between icon and text
                              Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 12), // Adjust button text size
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showItemDetailsDialog(String itemName, String itemDescription,
      String imageUrl, String itemStatus) {
    // Check if the item status is "Waiting for confirmation" before showing the dialog
    if (itemStatus != "Waiting for confirmation") {
      // Show a snackbar message instead of opening the dialog
      final snackBar = SnackBar(
        content: Text('Cannot confirm item with status: $itemStatus'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  itemName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 10),
                Text(
                  "Description:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(itemDescription),
                SizedBox(height: 10),
                Text(
                  "Status:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(itemStatus),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                    if (itemStatus == "Waiting for confirmation")
                      ElevatedButton(
                        onPressed: () {
                          _confirmItem(
                              itemName); // Call a function to confirm the item
                          Navigator.of(context).pop();
                        },
                        child: Text('Confirm'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmItem(String itemName) async {
    try {
      await _firestore
          .collection('Items')
          .doc('book')
          .collection('dataItems')
          .where('item_name', isEqualTo: itemName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update(
              {'status': 'Confirmed'}); // Update the status to 'Confirmed'
        });
      });
    } catch (e) {
      // Handle any errors that occur
      print('Error confirming item: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      String itemName, String itemStatus) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteItem(itemName);

                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.red), // สีพื้นหลัง
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // สีตัวอักษร
              ),
              child: Column(
                children: [
                  SizedBox(width: 10), // เพิ่มระยะห่างระหว่างไอคอนและข้อความ
                  Text('Delete'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String itemName) async {
    try {
      await _firestore
          .collection('Items')
          .doc('book')
          .collection('dataItems')
          .where('item_name', isEqualTo: itemName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      // หรือใช้เงื่อนไขอื่น ๆ ที่เหมาะสมกับโครงสร้างของคุณ
    } catch (e) {
      // จัดการข้อผิดพลาด (error) ถ้ามี
      print('Error deleting item: $e');
    }
  }
}
