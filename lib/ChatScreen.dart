import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.userName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Rounded container for chat
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9CF93),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              // Add your chat content here
            ),
          ),
          // Row with text input and icons for sending messages, voice notes, pictures, and videos
          _buildTextInputRow(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD6CBBB),
        items: [
          _buildBottomNavigationBarItem(Icons.home, 'Home', 0),
          _buildBottomNavigationBarItem(Icons.chat, 'Chat', 1),
          _buildBottomNavigationBarItem(Icons.person, 'Profile', 2),
        ],
        currentIndex: 1, // Assuming this is the 'Chat' page
        onTap: (index) {
          // Handle bottom navigation taps
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          if (index == 1)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9CF93),
                ),
                child: const Text(''),
              ),
            ),
        ],
      ),
      label: label,
    );
  }

  Widget _buildTextInputRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // Add your text input properties and controllers
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Implement sending message functionality
            },
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Add Image'),
                onTap: () {
                  // Handle adding image functionality
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Add Video'),
                onTap: () {
                  // Handle adding video functionality
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
