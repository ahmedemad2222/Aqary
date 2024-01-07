import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final String _messagesTable = 'messages';

  late Database _localDatabase;

  ChatService() {
    _initLocalDatabase();
  }

  Future<void> _initLocalDatabase() async {
    _localDatabase = await openDatabase(
      'chat_local_db.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_messagesTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senderId TEXT,
            senderEmail TEXT,
            receiverId TEXT,
            message TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> _saveMessageLocally(Message message) async {
    await _localDatabase.insert(
      _messagesTable,
      message.toMapForLocalDb(),
    );
  }

  Future<List<Message>> getLocalMessages(
      String userId, String otherUserId) async {
    List<Map<String, dynamic>> messages = await _localDatabase.rawQuery('''
      SELECT * FROM $_messagesTable
      WHERE (senderId = ? AND receiverId = ?)
      OR (senderId = ? AND receiverId = ?)
      ORDER BY timestamp ASC
    ''', [userId, otherUserId, otherUserId, userId]);

    return messages.map((map) => Message.fromLocalDbMap(map)).toList();
  }

  Future<List<Message>> getAllLocalMessages() async {
    List<Map<String, dynamic>> messages =
        await _localDatabase.rawQuery('SELECT * FROM $_messagesTable');
    return messages.map((map) => Message.fromLocalDbMap(map)).toList();
  }

  Future<List<Message>> getLocalMessagesBySenderId(String senderId) async {
    List<Map<String, dynamic>> messages = await _localDatabase.rawQuery('''
    SELECT * FROM $_messagesTable
    WHERE senderId = ?
  ''', [senderId]);

    return messages.map((map) => Message.fromLocalDbMap(map)).toList();
  }

  // Post Messages
  Future<void> sendMessage(String receiverUserId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverUserId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection("Chat_Rooms")
        .doc(chatRoomId)
        .collection("Messages")
        .add(newMessage.toMapForLocalDb());

    await _saveMessageLocally(newMessage);
  }

  // Get Messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
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
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMapForLocalDb() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.microsecondsSinceEpoch,
    };
  }

  factory Message.fromLocalDbMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: Timestamp.fromMicrosecondsSinceEpoch(map['timestamp']),
    );
  }
}
