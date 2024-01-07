import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/ChatService.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatPage1 extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserid;

  const ChatPage1({
    Key? key,
    required this.reciverUserEmail,
    required this.reciverUserid,
  }) : super(key: key);

  @override
  State<ChatPage1> createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    // Initialize FCM
    _configureFCM();
    _initLocalNotifications();
    // Rest of your existing initState code...
  }
  void _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    //final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void _showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Aqary_chat_message', // my channel ID
      'Aqary Chat Message', // my channel name
      //'You received a message in Aqary', // my channel description
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title ?? 'Aqary has a New Message for you', // Notification title
      body ?? 'You have a new message', // Notification body
      platformChannelSpecifics,
    );
  }

  void _configureFCM() {
    // Configure FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming FCM message when the app is in the foreground
      _showLocalNotification(message.notification?.title, message.notification?.body);
    });

  void _handleNotificationTap(RemoteMessage message) {
  // Extract information from the FCM message
  final String senderId = message.data['senderId']; // Assuming you include senderId in the FCM payload
  final String senderEmail = message.data['senderEmail']; // Assuming you include senderEmail in the FCM payload

  // Navigate to the chat page with the necessary parameters
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ChatPage1(
        reciverUserid: senderId,
        reciverUserEmail: senderEmail,
      ),
    ),
  );
  }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when the app is opened from a terminated state
      // You can navigate to the chat page or handle it as needed
      _handleNotificationTap(message);
    });
    _firebaseMessaging.getToken().then((token) {
    print("FCM Token: $token");
    // Send this token to your server for targeted messaging
  });
  

    // Retrieve FCM token
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      // Send this token to your server for targeted messaging
    });
  }


  void SendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.reciverUserid,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverUserEmail),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  top: MediaQuery.of(context).size.height / 6.3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF9CF93),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: StreamBuilder(
                      stream: _chatService.getMessages(
                        widget.reciverUserid,
                        _firebaseAuth.currentUser!.uid,
                      ),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          print('Waiting for data...');
                          return CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          print('No messages found.');
                          return Text('No messages Yet, Start a conversation.');
                        }

                        print('Received ${snapshot.data!.docs.length} messages.');

                        return ListView(
                          children: snapshot.data!.docs
                              .map((document) => _buildMessageItem(document))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set the index for the 'Chat' icon
        onTap: (index) {
          // Handle navigation as needed
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
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

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var isCurrentUser = (data['senderId'] == _firebaseAuth.currentUser!.uid);
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            _buildProfilePicture(data['senderId']), // Show profile picture for incoming messages
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust the maximum width
            ),
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['message'],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(String senderId) {
    // Replace this logic with your own way of retrieving and displaying profile pictures
    // For example, you can use a CircleAvatar widget with an image provider.
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage('https://example.com/profile-image/$senderId.jpg'),
      // Use the appropriate URL or image source for the sender's profile picture
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message...',
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: SendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}