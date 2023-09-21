import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/addnewItem.dart';
import 'package:finalproject/views/category.dart';
import 'package:finalproject/views/categorypage/bookpage.dart';
import 'package:finalproject/views/categorypage/clothpage.dart';
import 'package:finalproject/views/categorypage/electricalpage.dart';
import 'package:finalproject/views/categorypage/sportpage.dart';
import 'package:finalproject/views/categorypage/stationerypage.dart';
import 'package:finalproject/views/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FerniturePage extends StatefulWidget {
  const FerniturePage({super.key});

  @override
  State<FerniturePage> createState() => _FerniturePageState();
}

class _FerniturePageState extends State<FerniturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          // เมื่อแท็บถูกเลือกให้ทำการเปลี่ยนหน้าด้วย Navigator
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoriesPage(),
            ));
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddMoreNewItem(),
            ));
          } else if (index == 2) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ProfilePage(); // หน้าปลายทางที่คุณต้องการเปลี่ยนไป
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        backgroundColor: Colors.blue[900],
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: Colors.white54,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.white54,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_3_rounded,
              color: Colors.white54,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 20, // กำหนดความสูงตามที่คุณต้องการ
              color: Colors.white,
            ),
            Text(
              'Ferniture Category',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.black),
            ),
            Container(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  // Define a list of specific texts
                  List<String> specificTexts = [
                    'Book',
                    'Cloth',
                    'Electrical',
                    'Ferniture',
                    'Sport',
                    'Stationery',
                  ];
                  List<String> imagePaths = [
                    'assets/images/book.jpg',
                    'assets/images/cloth.png',
                    'assets/images/electrical.jpg',
                    'assets/images/ferniture.jpg',
                    'assets/images/sport.jpg',
                    'assets/images/stationery.jpg',
                  ];

                  return GestureDetector(
                    onTap: () {
                      switch (specificTexts[index]) {
                        case 'Book':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookPage(),
                            ),
                          );
                          break;
                        case 'Cloth':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClothPage(),
                            ),
                          );
                          break;
                        case 'Electrical':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ElectricalPage(),
                            ),
                          );
                          break;
                        case 'Ferniture':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FerniturePage(),
                            ),
                          );
                          break;
                        case 'Sport':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SportPage(),
                            ),
                          );
                          break;
                        case 'Stationery':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StationeryPage(),
                            ),
                          );
                          break;
                      }
                    },
                    child: Card(
                      color: Colors.white.withOpacity(1),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.asset(
                              imagePaths[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            specificTexts[
                                index], // Use specific text based on the index
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 1, // กำหนดความสูงตามที่คุณต้องการ
              color: Colors.black,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Items')
                    .doc('ferniture')
                    .collection('dataItems')
                    .where('status', whereIn: [
                  'Waiting for confirmation',
                  'Available'
                ]).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data?.docs.isEmpty == true) {
                    // Display a message when there are no items.
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
                      var itemStatus =
                          item['status']; // เพิ่มการเรียกข้อมูลสถานะของสิ่งของ

                      // เลือกสีของรายการสิ่งของตามสถานะ
                      Color itemColor = itemStatus == 'Waiting for confirmation'
                          ? Colors
                              .yellow // สีเหลืองสำหรับสิ่งของที่อยู่ในสถานะ "Waiting for confirmation"
                          : Colors
                              .white; // สีขาวสำหรับสิ่งของที่ไม่ได้อยู่ในสถานะ "Waiting for confirmation"

                      return Padding(
                        padding: const EdgeInsets.all(1),
                        child: Card(
                          elevation: 4,
                          color: itemColor, // ใช้สีตามสถานะที่เลือก
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              itemName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(itemDescription),
                            leading: imageUrl != null
                                ? Container(
                                    width:
                                        100, // กำหนดความกว้างที่ต้องการที่นี่
                                    height: 100, // กำหนดความสูงที่ต้องการที่นี่
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    _showItemDetailsDialog(
                                        item.data() as Map<String, dynamic>,
                                        item.reference);
                                  },
                                  child: Text("Details"),
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
            ),
          ],
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

  DateTime currentTime = DateTime.now();
}
