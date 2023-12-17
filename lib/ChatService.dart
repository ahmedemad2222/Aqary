import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//Post Messages
  Future<void> sendMessage(String reciverUserid, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        SenderId: currentUserId,
        SenderEmail: currentUserEmail,
        reciverId: reciverUserid,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, reciverUserid];
    ids.sort();
    String ChatRoomId = ids.join("_");

    await _firestore
        .collection("Chat_Rooms")
        .doc(ChatRoomId)
        .collection("Messages")
        .add(newMessage.toMap());
  }

//Get Messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    print('Fetching messages for Chat Room ID: $chatRoomId');

    return _firestore
        .collection("Chat_Rooms")
        .doc(chatRoomId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((querySnapshot) {
      print('Received ${querySnapshot.docs.length} messages.');

      // Print each message data
      for (var doc in querySnapshot.docs) {
        print('Message ID: ${doc.id}');
        print('Sender ID: ${doc['senderId']}');
        print('Message: ${doc['message']}');
        print('Timestamp: ${doc['timestamp']}');
        print('---');
      }

      return querySnapshot;
    });
  }
}

class Message {
  final String SenderId;
  final String SenderEmail;
  final String reciverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.SenderId,
      required this.SenderEmail,
      required this.reciverId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': SenderId,
      'SenderEmail': SenderEmail,
      'reciverId': reciverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
