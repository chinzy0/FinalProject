import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivedHistorypage extends StatefulWidget {
  const ReceivedHistorypage({super.key});

  @override
  State<ReceivedHistorypage> createState() => _ReceivedHistorypageState();
}

class _ReceivedHistorypageState extends State<ReceivedHistorypage> {
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
          "Received History",
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
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('Items')
            .doc(selectedDocument)
            .collection('dataItems')
            .where('receiver_uid', isEqualTo: currentUserId)
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
              bool isCancelButtonEnabled = itemStatus != 'Confirmed';

              return FutureBuilder<DocumentSnapshot>(
                future:
                    _firestore.collection('Users').doc(item['user_id']).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  } else if (!userSnapshot.hasData ||
                      userSnapshot.data == null) {
                    return Text('No user data available');
                  }

                  var uploaderData = userSnapshot.data!;
                  var uploaderName = uploaderData['name'];
                  var uploaderEmail = uploaderData['email'];
                  var uploaderTel = uploaderData['tel'];
                  var uploaderLineID = uploaderData['idline'];

                  return SizedBox(
                    child: Card(
                      elevation: 2,
                      color: itemStatus == 'Waiting for confirmation'
                          ? Colors.yellow
                          : itemStatus == 'Confirmed'
                              ? Colors.grey
                              : Colors.white,
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
                                    imageUrl,
                                    itemUid,
                                    itemName,
                                    itemDescription,
                                    itemStatus,
                                    uploaderName,
                                    uploaderEmail,
                                    uploaderTel,
                                    uploaderLineID,
                                    receiveTime);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(8.0)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(80, 30)),
                              ),
                              child: Text(
                                "Details",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: isCancelButtonEnabled
                                  ? () {
                                      _showDeleteConfirmationDialog(
                                          itemUid, itemName);
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(8.0)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(80, 30)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'Cancel',
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
          );
        },
      ),
    );
  }

  void _showItemDetailsDialog(
      String imageUrl,
      String itemUid,
      String itemName,
      String itemDescription,
      String itemStatus,
      String uploaderName,
      String uploaderEmail,
      String uploaderTel,
      String uploaderLineID,
      dynamic receiveTime) {
    // Check if the receiveTime field exists and is a Timestamp
    if (receiveTime is! Timestamp) {
      final snackBar = SnackBar(
        content: Text('Invalid receiveTime data'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final formattedReceiveTime =
        DateFormat(' HH:mm dd MMMM yyyy').format(receiveTime.toDate());

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
                  Text(itemUid),
                  Text(
                    "Item Name:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(itemName),
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
                    "Uploader Name:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(uploaderName), SizedBox(height: 10),
                  Text(
                    "Email:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(uploaderEmail),
                  SizedBox(height: 10),
                  Text(
                    "Tel:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(uploaderTel),
                  SizedBox(height: 10),
                  Text(
                    "Line ID:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(uploaderLineID),
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

  Future<void> _showDeleteConfirmationDialog(
      String itemUid, String itemName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel'),
          content: Text('Are you sure you want to cancel $itemName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update data in Firestore
                await FirebaseFirestore.instance
                    .collection('Items')
                    .doc(selectedDocument)
                    .collection('dataItems')
                    .doc(itemUid)
                    .update({
                  'receiver_uid': '',
                  'receive_time': '',
                  'status': 'Available',
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Column(
                children: [
                  SizedBox(width: 10),
                  Text('Confirm'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
