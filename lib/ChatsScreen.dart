import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ChatPage1.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/profile.dart';

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
      body: Column(
        children: [
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found');
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final doc in snapshot.data!.docs)
                        _buildUserProfilePicture(doc),
                    ],
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF9CF93),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found');
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];

                      // Skip the logged-in user
                      if (doc['uid'] == _firebaseAuth.currentUser!.uid) {
                        return SizedBox.shrink();
                      }

                      return _buildUserListItem(doc);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Current screen, do nothing or handle accordingly
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget _buildUserProfilePicture(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String profilePictureUrl =
        data['profilePictureUrl'] ?? 'https://example.com/default-profile.png';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(profilePictureUrl),
        radius: 20.0,
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String profilePictureUrl =
        data['profilePictureUrl'] ?? 'https://example.com/default-profile.png';

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Chat_Rooms')
          .doc(_getChatRoomId(data['uid']))
          .collection('Messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Error');
        }

        String lastMessage = 'No messages yet';

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          lastMessage = snapshot.data!.docs[0]['message'];
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profilePictureUrl),
          ),
          title: Text(data['email'] ?? 'Unknown Email'),
          subtitle: Text(lastMessage),
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
      },
    );
  }

  String _getChatRoomId(String otherUserId) {
    List<String> ids = [_firebaseAuth.currentUser!.uid, otherUserId];
    ids.sort();
    return ids.join("_");
  }
}
