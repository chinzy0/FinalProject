import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InterestingPage extends StatefulWidget {
  const InterestingPage({super.key});

  @override
  State<InterestingPage> createState() => _InterestingPageState();
}

class _InterestingPageState extends State<InterestingPage> {
  String? currentUserCategory;

  DateTime currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    // Retrieve the user's category when the page loads.
    getUserCategory();
  }

  Future<void> getUserCategory() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        currentUserCategory = userDoc.get('category');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Interests",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Your interests',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Items')
                            .doc(
                                currentUserCategory) // Assuming currentUserCategory is the document ID
                            .collection(
                                'dataItems') // Assuming dataItems is the subcollection within the document
                            .where('status', whereIn: [
                          'Waiting for confirmation',
                          'Available'
                        ]).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data?.docs.isEmpty == true) {
                            return Center(
                              child: Text(
                                'No items available',
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }

                          var items = snapshot.data?.docs ?? [];

                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: items.map((item) {
                              var itemName = item['item_name'];
                              var itemDescription = item['detail'];
                              var imageUrl = item['image_url'];
                              var itemStatus = item['status'];

                              Color itemColor =
                                  itemStatus == 'Waiting for confirmation'
                                      ? Colors.yellow
                                      : Colors.white;

                              return Column(
                                children: [
                                  Card(
                                    elevation: 4,
                                    color: itemColor,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (imageUrl != null)
                                            Container(
                                              width: 250,
                                              height: 250,
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              itemName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(itemDescription),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showItemDetailsDialog(
                                          item.data() as Map<String, dynamic>,
                                          item.reference);
                                    },
                                    child: Text("Details"),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 15,
                color: Colors.white,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetailsDialog(
      Map<String, dynamic> itemData, DocumentReference itemRef) {
    String itemName = itemData['item_name'];
    String itemDetail = itemData['detail'];
    String itemStatus = itemData['status'];
    String imageUrl = itemData['image_url'];
    String userId = itemData['user_id'];

    Timestamp? uploadTime = itemData['upload_time'] as Timestamp?;

    FirebaseAuth auth = FirebaseAuth.instance;
    String? currentUserId = auth.currentUser?.uid;

    if (currentUserId != null && currentUserId == userId) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Item Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text('You cannot accept your own item.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection('Users') // Replace with your user collection name
          .doc(userId) // Document ID of the user
          .get()
          .then((userData) {
        if (userData.exists) {
          String userName = userData['name'];
          String userEmail = userData['email'];
          String userTel = userData['tel'];
          String userLineID = userData['idline'];

          showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: AlertDialog(
                  title: Text(
                    'Item Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imageUrl != null)
                        Center(
                          child: Image.network(
                            imageUrl,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(
                        'Item Name:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(itemName, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Detail:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(itemDetail, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Status:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(itemStatus, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Uploaded by:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('$userName ', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('$userEmail', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Tel:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('$userTel', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'LineID:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('$userLineID', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Upload Time:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        uploadTime != null
                            ? DateFormat(' HH:mm dd MMMM yyyy')
                                .format(uploadTime.toDate())
                            : '',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (itemStatus != 'Waiting for confirmation') {
                          // Store the UID of the receiver
                          String receiverUid =
                              FirebaseAuth.instance.currentUser?.uid ?? '';

                          // Call a function to change the item status and pass the receiver's UID
                          _changeItemStatus(itemRef, receiverUid);

                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Item Status',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  'This item is already in "Waiting for confirmation" status.',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Accept'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // Handle the case where user data does not exist.
          print('User data does not exist.');
        }
      }).catchError((error) {
        // Handle errors when fetching user data.
        print('Error fetching user data: $error');
      });
    }
  }

  void _changeItemStatus(DocumentReference itemRef, String receiverUid) {
    // Assuming your Firestore documents have a "status" field and a "receiver_uid" field.
    // You can update the status and receiver UID as needed.
    itemRef.update({
      'status': 'Waiting for confirmation',
      'receiver_uid': receiverUid,
      'receive_time': currentTime,
    }).then((_) {
      // Item status updated successfully.
      // You can add any additional logic here if needed.
    }).catchError((error) {
      // Handle errors here if the update fails.
      print('Error updating item status: $error');
    });
  }
}
