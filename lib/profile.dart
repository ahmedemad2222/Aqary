import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/NavBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 2;
  late String email = '';
  late String name = '';

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch data from Firebase
  Future<Map<String, dynamic>> fetchData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use user.uid to get the UID
        DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();

        if (documentSnapshot.exists) {
          // Check if the document exists before accessing its data
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          email = data['email'] ?? 'No Email';
          name = data['name'] ?? 'No Name';
          return {'email': email, 'name': name};
        } else {
          print('Document does not exist');
          return {'email': 'No Email', 'name': 'No Name'};
        }
      } else {
        print('User not logged in');
        return {'email': 'No Email', 'name': 'No Name'};
      }
    } catch (e) {
      print('Error fetching data: $e');
      return {'email': 'No Email', 'name': 'No Name'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Data fetching is complete, update the email and name
              email = snapshot.data?['email'] ?? 'No Email';
              name = snapshot.data?['name'] ?? 'No Name';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Your existing widget code...
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Color.fromARGB(255, 227, 183, 121),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/profile_picture.jpg'),
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Color.fromARGB(255, 227, 183, 121),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProfileInfoRow('Name', name,
                            labelFontSize: 20.0, valueFontSize: 18.0),
                        buildProfileInfoRow('Email', email,
                            labelFontSize: 20.0, valueFontSize: 18.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 70.0),
                  buildHelpAndSupportRow(),
                  SizedBox(height: 40.0),
                  buildAboutUsRow(),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () {
                      _logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF9CF93),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // Still waiting for data
              return Center(child: CircularProgressIndicator());
            } else {
              // An error occurred
              return Center(child: Text('Error fetching data'));
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  // The rest of your class...

  Widget buildProfileInfoRow(String label, String value,
      {double labelFontSize = 16.0, double valueFontSize = 16.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: labelFontSize, color: Colors.white)),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(fontSize: valueFontSize, color: Colors.black),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(label, value);
            },
          ),
        ],
      ),
    );
  }

  Widget buildHelpAndSupportRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.help, size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
            SizedBox(width: 16.0),
            Text(
              'Help & Support',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
      ],
    );
  }

  Widget buildAboutUsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.info, size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
            SizedBox(width: 16.0),
            Text(
              'About Us',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
      ],
    );
  }

  Future<void> _showEditDialog(String label, String value) async {
    TextEditingController? controller;

    switch (label) {
      case 'name':
        controller = TextEditingController();
        break;
      case 'email':
        controller = TextEditingController();
        break;
      case 'Phone':
        controller = TextEditingController();
        break;
    }

    controller ??= TextEditingController();
    controller.text = value;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: SingleChildScrollView(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String editedValue = controller?.text ?? '';
                print('Edited $label: $editedValue');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Login')),
      (route) => false,
    );
  }
}
