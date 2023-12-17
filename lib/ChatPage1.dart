import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/ChatService.dart';

class ChatPage1 extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserid;

  const ChatPage1(
      {super.key, required this.reciverUserEmail, required this.reciverUserid});

  @override
  State<ChatPage1> createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void SendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.reciverUserid, _messageController.text);
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
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Add a print statement to check the content of the message
    print('Message content: ${data['message']}');

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(
            data['message'],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          obscureText: false,
        )),
        IconButton(onPressed: SendMessage, icon: const Icon(Icons.arrow_right))
      ],
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
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

        // Print the number of messages received
        print('Received ${snapshot.data!.docs.length} messages.');

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
}
