import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/addnewItem.dart';
import 'package:finalproject/views/category.dart';
import 'package:finalproject/views/categorypage/bookpage.dart';
import 'package:finalproject/views/categorypage/clothpage.dart';
import 'package:finalproject/views/categorypage/electricalpage.dart';
import 'package:finalproject/views/categorypage/sportpage.dart';
import 'package:finalproject/views/categorypage/stationerypage.dart';
import 'package:finalproject/views/profilepage.dart';
import 'package:flutter/material.dart';

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
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var items = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      var itemName = item['item_name'];
                      var itemDescription = item['detail'];
                      var imageUrl = item[
                          'image_url']; // Replace 'image_url' with the actual field name for the image URL.

                      return Padding(
                        padding: const EdgeInsets.all(
                            1), // Add padding around each item.
                        child: Card(
                          elevation:
                              4, // Add elevation to the card for a shadow effect.
                          child: ListTile(
                            contentPadding: EdgeInsets.all(
                                10), // Add padding within the ListTile.
                            title: Text(itemName,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            subtitle: Text(itemDescription),
                            leading: imageUrl != null
                                ? Image.network(imageUrl,
                                    width: 100, height: 300)
                                : null,
                            // Customize the image size with 'width' and 'height'.
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

  Widget getItem(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var items = snapshot.docs;

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          var itemData = items[index].data() as Map<String, dynamic>;

          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      itemData[
                          'image'], // Replace 'image' with the actual field name in your Firestore document
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  itemData[
                      'title'], // Replace 'title' with the actual field name in your Firestore document
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
