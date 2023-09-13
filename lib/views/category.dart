import 'package:finalproject/views/addnewItem.dart';
import 'package:finalproject/views/profilepage.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    ProfilePage(),
    AddMoreNewItem(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ));
          }
        },
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
      body: ListView(
        children: [
          
          Padding(
            padding: EdgeInsets.only(left: 3, bottom: 5, top: 15),
            child: Text(
              "Category",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.black),
            ),
          ),
          BookCategory(),
          ClothCategory(),
          ElectricalCategory(),
          FernitureCategory(),
          SportCategory(),
          StationeryCategory()
        ],
      ),
    );
  }

  Widget BookCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/book.jpg"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Book',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget ClothCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/cloth.png"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Cloth',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget ElectricalCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/electrical.jpg"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Electrical',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget FernitureCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/ferniture.jpg"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Ferniture',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget SportCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/sport.jpg"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Sport',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget StationeryCategory() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print('Padding onTap');
        },
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/stationery.jpg"),
                fit: BoxFit.fitWidth,
              )),
          child: Center(
            child: Text(
              'Stationery',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
