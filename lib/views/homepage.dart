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
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "Reused leftover Items",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Serch here",
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.5)),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 3, bottom: 15),
            child: Text(
              "Reused leftover Items",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/book.jpg"),
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/cloth.png"),
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/electrical.jpg"),
                    fit: BoxFit.fitWidth),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/ferniture.jpg"),
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/sport.jpg"),
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/stationery.jpg"),
                      fit: BoxFit.fitWidth)),
            ),
          ),
        ],
      ),
    );
  }
}
