import 'package:finalproject/services/auth_service.dart';
import 'package:finalproject/views/editprofilepage.dart';
import 'package:finalproject/views/loginpage.dart';
import 'package:finalproject/views/receivehistory.dart';
import 'package:finalproject/views/uploadhistorypage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userData = await _auth.getUserData(uid);

    setState(() {
      this.userData = userData;
    });
  }

  Future<void> _editProfile() async {
    final updatedUserData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfilePage(userData: userData)),
    );

    if (updatedUserData != null) {
      setState(() {
        userData = updatedUserData;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: Image.asset('assets/images/user.jpg').image,
                ),
                const SizedBox(height: 50),
                if (userData != null)
                  Column(
                    children: [
                      _buildUserDataItem('Name:', userData['name'] ?? ''),
                      _buildUserDataItem('Telephone:', userData['tel'] ?? ''),
                      _buildUserDataItem('Line ID:', userData['idline'] ?? ''),
                      _buildUserDataItem(
                          'Interests', userData['category'] ?? ''),
                    ],
                  )
                else
                  Text('Loading user data...'),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Edit Profile', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 7.5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UploadHistoryPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // รูปร่าง
                            ),
                          ),
                          child: Text('Upload history',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.5, right: 15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReceivedHistorypage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Received history',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // สีพื้นหลัง
                      onPrimary: Colors.white, // สีข้อความ
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // รูปร่าง
                      ),
                    ),
                    child: Text('Sign Out', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      // เมื่อ Sign Out สำเร็จ นำทางผู้ใช้ไปยังหน้าล็อกอินหรือหน้าเข้าสู่ระบบ
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(), // แทนที่ LoginPage ด้วยหน้าที่คุณต้องการ
        ),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
