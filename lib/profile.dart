import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 0;
  // Define controllers for the editable fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Color.fromARGB(255, 227, 183, 121),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with the actual path
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {}, // Add your action here
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'User@gmailcom',
                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Color.fromARGB(255, 227, 183, 121),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProfileInfoRow('Name', 'John Doe', labelFontSize: 20.0, valueFontSize: 18.0),
                    buildProfileInfoRow('Email', 'john.doe@example.com', labelFontSize: 20.0, valueFontSize: 18.0),
                    buildProfileInfoRow('Phone', '+1 123 456 7890', labelFontSize: 20.0, valueFontSize: 18.0),
                  ],
                ),
              ),
              SizedBox(height: 100.0),
              buildHelpAndSupportRow(),
              SizedBox(height: 60.0),
              buildAboutUsRow(),
            ],
          ),
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

  // int _currentIndex = 2;

  // BottomNavigationBarItem buildBottomNavigationBarItem(
  //     IconData icon, String label, int index) {
  //   return BottomNavigationBarItem(
  //     icon: Icon(icon),
  //     label: label,
  //   );
  // }

  Widget buildProfileInfoRow(String label, String value, {double labelFontSize = 16.0, double valueFontSize = 16.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: labelFontSize, color: Colors.white)),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {}, // Add your action here
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(fontSize: valueFontSize, color: Colors.black), // Set text color to black
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle edit functionality here
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

  // Function to show the edit dialog
 Future<void> _showEditDialog(String label, String value) async {
  TextEditingController? controller;

  switch (label) {
    case 'Name':
      controller = nameController;
      break;
    case 'Email':
      controller = emailController;
      break;
    case 'Phone':
      controller = phoneController;
      break;
  }

  // Initialize the controller if it hasn't been assigned
  controller ??= TextEditingController();

  // Set the initial text in the text field to the current value
  controller.text = value;

  // Show the dialog
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
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // Adjust the padding as needed
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save the edited value
              String editedValue = controller?.text ?? '';
              // TODO: Add logic to save the edited value (e.g., update it in a database)
              print('Edited $label: $editedValue');
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
}