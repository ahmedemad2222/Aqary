import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<chatPage> {
  int currentIndex = 1; // Default to the 'Chat' page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement your search functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal scrollable list of icons and search icon
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  // Implement your search functionality here
                },
              ),
              Expanded(
                child: Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Replace with the actual number of chat icons
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black, // Replace with your color
                          child: Text('JD'), // Replace with user's initials
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // Container with curved edges and scrollable past chats
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF9CF93),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: List.generate(
                    10, // Replace with the actual number of past chats
                        (index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/user_image.jpg'),
                        ),
                        title: Text('John Doe'), // Replace with user's name
                        subtitle: Text(
                            'Last conversation at 10:30 AM'), // Replace with last conversation time
                        // Add more details or actions as needed
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD6CBBB),
        items: [
          buildBottomNavigationBarItem(Icons.home, 'Home', 0),
          buildBottomNavigationBarItem(Icons.chat, 'Chat', 1),
          buildBottomNavigationBarItem(Icons.person, 'Profile', 2),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          if (index == currentIndex)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9CF93),
                ),
                child: Text(''),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
