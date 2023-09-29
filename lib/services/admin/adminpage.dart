import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String selectedDocument = 'book';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Admin Page",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        actions: [
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
                PopupMenuItem<String>(
                  value: 'electrical',
                  child: Text('Electrical'),
                ),
                PopupMenuItem<String>(
                  value: 'ferniture',
                  child: Text('Ferniture'),
                ),
                PopupMenuItem<String>(
                  value: 'sport',
                  child: Text('Sport'),
                ),
                PopupMenuItem<String>(
                  value: 'stationery',
                  child: Text('Stationery'),
                ),
              ];
            },
            icon: Icon(Icons.menu_book_rounded),
          ),
          IconButton(
            icon: Icon(Icons.logout), // Add a logout icon
            onPressed: () {
              _handleLogout(); // Call the logout function when pressed
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .doc(selectedDocument) // Use selected document here.
            .collection('dataItems')
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
              var itemUid = item['item_uid'];
              var itemName = item['item_name'];
              var itemDescription = item['detail'];
              var imageUrl = item['image_url'];
              var itemStatus = item['status'];
              var receiveTime = item['receive_time'];

              // Define colors based on item status
              Color cardColor = itemStatus == 'Waiting for confirmation'
                  ? Colors.yellow
                  : itemStatus == 'Confirmed'
                      ? Colors.grey
                      : Colors.white; // Default card color

              return SizedBox(
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
                            _showItemDetailsDialog(
                              item['item_uid'],
                              itemName,
                              itemDescription,
                              imageUrl,
                              itemStatus,
                              item['receive_time'],
                            );
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
                            "Manage",
                            style: TextStyle(
                                fontSize: 12), // Adjust button text size
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                itemUid, itemName, itemStatus);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(8.0)),
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Delete',
                                style: TextStyle(fontSize: 12),
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

  void _showItemDetailsDialog(
    String itemUid,
    String itemName,
    String itemDescription,
    String imageUrl,
    String itemStatus,
    dynamic receiveTime,
  ) {
    String formattedReceiveTime = 'Have not received it yet.';

    // Check if receiveTime is not null and is an instance of Timestamp
    if (receiveTime != null && receiveTime is Timestamp) {
      formattedReceiveTime =
          DateFormat(' HH:mm dd MMMM yyyy').format(receiveTime.toDate());
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Dialog(
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
                    "Item UID:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(itemUid), // Display item UID
                  SizedBox(height: 10),
                  Text(
                    "Detail:",
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
                  SizedBox(height: 10),

                  Text(
                    "Received Time:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(formattedReceiveTime), // Display formatted receive time
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _resetItemStatus(
                              itemUid); // Call a function to reset the item status
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white), // Change the button color
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Text('Re-Post'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _confirmItem(
                              itemUid); // Call a function to confirm the item
                          Navigator.of(context).pop();
                        },
                        child: Text('Confirm'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.blue), // Change the button color
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Manage category'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Function to reset item status
  void _resetItemStatus(String itemUid) {
    try {
      _firestore
          .collection('Items')
          .doc(selectedDocument)
          .collection('dataItems')
          .doc(itemUid) // Use itemUid to uniquely identify the document
          .update({
        'status': 'Available',
        'receiver_uid': FieldValue.delete(),
        'receive_time': '',
      });
    } catch (e) {
      // Handle any errors that occur
      print('Error resetting item status: $e');
    }
  }

  Future<void> _confirmItem(String itemUid) async {
    try {
      await _firestore
          .collection('Items')
          .doc(selectedDocument)
          .collection('dataItems')
          .doc(itemUid) // Use itemUid to uniquely identify the document
          .update({'status': 'Confirmed'});
    } catch (e) {
      // Handle any errors that occur
      print('Error confirming item: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      String itemUid, String itemName, String itemStatus) async {
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
                _deleteItem(itemUid, itemName);

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

  Future<void> _deleteItem(String itemUid, String itemName) async {
    try {
      await _firestore
          .collection('Items')
          .doc(selectedDocument)
          .collection('dataItems')
          .doc(itemUid) // Use itemUid to uniquely identify the document
          .delete();
    } catch (e) {
      // Handle any errors that occur
      print('Error deleting item: $e');
    }
  }

  Future<void> _handleLogout() async {
    try {
      await auth.signOut();
      // Navigate to the login or home screen after logout (you can customize this part)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    } catch (e) {
      // Handle any errors that occur during logout
      print('Error during logout: $e');
    }
  }
}
