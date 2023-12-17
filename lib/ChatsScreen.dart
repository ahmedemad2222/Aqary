import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ChatPage1.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: _buildUserList(), // Call _buildUserList here
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for data.
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Handle error case.
          print('Error: ${snapshot.error}');
          return Text('Error');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Handle case where there is no data.
          return Text('No users found');
        }

        return ListView(
          children: snapshot.data!.docs
              .where((doc) => _firebaseAuth.currentUser!.email != doc['email'])
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return ListTile(
      title: Text(data['email']),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage1(
              reciverUserEmail: data['email'],
              reciverUserid: data['uid'],
            ),
          ),
        );
      },
    );
  }
}
