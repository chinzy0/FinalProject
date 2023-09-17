import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/views/categorypage/bookpage.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.40),
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_rounded),
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
              height: 50, // กำหนดความสูงตามที่คุณต้องการ
              color: Colors.white,
            ),
            Text(
              'Category',
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
                      // Navigate to the corresponding route when the card is tapped
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
            SizedBox(
              height: 20,
            ),
            Container(
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
                        'assets/images/ferniture.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      '123', // Use specific text based on the index
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
