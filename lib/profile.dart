import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/OfferedApartments.dart';
import 'package:flutter_application_1/ThemeProvider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 2;
  late String email = '';
  late String name = '';
  late String profileImageUrl = '';
  late TextEditingController nameController;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      if (!dataLoaded) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();

          if (documentSnapshot.exists) {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;

            setState(() {
              email = data['email'] ?? 'No Email';
              name = data['name'] ?? 'No Name';
              List<String>? imageUrls = List<String>.from(data['imageUrls']);
              profileImageUrl = (imageUrls != null && imageUrls.isNotEmpty)
                  ? imageUrls[0]
                  : 'USER_PROFILE_IMAGE';
              nameController.text = name;
              dataLoaded = true;
            });
          } else {
            print('Document does not exist');
            setState(() {
              email = 'No Email';
              name = 'No Name';
              profileImageUrl = 'USER_PROFILE_IMAGE';
              dataLoaded = true;
            });
          }
        } else {
          print('User not logged in');
          setState(() {
            email = 'No Email';
            name = 'No Name';
            profileImageUrl = 'USER_PROFILE_IMAGE';
            dataLoaded = true;
          });
        }
      }
    } catch (e, stackTrace) {
      print('Error in fetchData: $e');
      print(stackTrace);
    }
  }

  Future<void> _updateUserData(String field, String updatedValue) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await users.doc(user.uid).update({field.toLowerCase(): updatedValue});

        setState(() {
          if (field.toLowerCase() == 'name') {
            name = updatedValue;
            nameController.text = updatedValue;
          } else if (field.toLowerCase() == 'email') {
            email = updatedValue;
          }
        });

        print('User data updated successfully');
      } else {
        print('User not logged in');
      }
    } catch (e, stackTrace) {
      print('Error updating user data: $e');
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    if (!dataLoaded) {
      // Show a loading indicator while data is being fetched
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color.fromARGB(255, 227, 183, 121),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 227, 183, 121),
      ),
      body: buildProfilePage(isDarkMode),
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

  Widget buildProfilePage(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDarkLightToggle(isDarkMode),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: isDarkMode
                ? Colors.black
                : const Color.fromARGB(255, 227, 183, 121),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: isDarkMode
                ? Colors.black
                : const Color.fromARGB(255, 227, 183, 121),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileInfoRow(
                  'Name',
                  name ?? 'Loading...',
                  isDarkMode,
                  labelFontSize: 20.0,
                  valueFontSize: 18.0,
                ),
                buildProfileInfoRow(
                  'Email',
                  email ?? 'Loading...',
                  isDarkMode,
                  labelFontSize: 20.0,
                  valueFontSize: 18.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 70.0),
          buildHelpAndSupportRow(isDarkMode),
          const SizedBox(height: 40.0),
          buildAboutUsRow(isDarkMode),
          const SizedBox(height: 40.0),
          buildOfferedApartments(),
          SizedBox(height: 40.0),
          ElevatedButton(
            onPressed: () {
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9CF93),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileInfoRow(String label, String value, bool isDarkMode,
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
                  style:
                      TextStyle(fontSize: labelFontSize, color: Colors.white)),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  _showEditDialog(label, value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? Colors.grey[800]
                      : const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: valueFontSize,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(label, value);
            },
          ),
        ],
      ),
    );
  }

  Widget buildHelpAndSupportRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.help,
                size: 30.0,
                color: isDarkMode
                    ? Colors.grey[800]
                    : const Color.fromARGB(255, 219, 177, 118)),
            const SizedBox(width: 16.0),
            const Text(
              'Help & Support',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios,
            size: 30.0,
            color: isDarkMode
                ? Colors.grey[800]
                : const Color.fromARGB(255, 219, 177, 118)),
      ],
    );
  }

  Widget buildAboutUsRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.info,
                size: 30.0,
                color: isDarkMode
                    ? Colors.grey[800]
                    : const Color.fromARGB(255, 219, 177, 118)),
            const SizedBox(width: 16.0),
            const Text(
              'About Us',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios,
            size: 30.0,
            color: isDarkMode
                ? Colors.grey[800]
                : const Color.fromARGB(255, 219, 177, 118)),
      ],
    );
  }

    Widget buildOfferedApartments() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OfferedApartments()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.home,
                  size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
              SizedBox(width: 16.0),
              Text(
                'My Apartments',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios,
              size: 30.0, color: Color.fromARGB(255, 219, 177, 118)),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(String label, String value) async {
    TextEditingController controller = TextEditingController();
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String updatedValue = controller.text.trim();

                if (updatedValue.isNotEmpty) {
                  await _updateUserData(label, updatedValue);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDarkLightToggle(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeProvider>().toggleDarkMode();
      },
      child: Container(
        height: 50.0,
        color: isDarkMode ? Colors.black : Colors.white,
        alignment: Alignment.center,
        child: Text(
          isDarkMode ? 'Dark Mode' : 'Light Mode',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Login')),
      (route) => false,
    );
  }
}
