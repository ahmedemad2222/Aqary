import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() {
  runApp(SearchPage());
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          backgroundColor: Color(0xFFF9CF93),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: SearchContent(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF514D47),
          selectedItemColor: Color(0xFFF9CF93),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class SearchContent extends StatefulWidget {
  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  int selectedRooms = 1;
  int selectedToilets = 1;

  final _firestore = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  Widget buildSearchButton() {
    return ElevatedButton.icon(
      key: Key('searchButton'), // Add a key for easier testing
      onPressed: () async {
        try {
          // Call Cloud Function with search criteria
          final HttpsCallableResult result =
              await _functions.httpsCallable('searchBuildings').call({
            'rooms': selectedRooms,
            'toilets': selectedToilets,
          });

          // Handle the search results
          if (result.data['success']) {
            // Successfully fetched buildings, handle the data
            List<dynamic> buildings = result.data['data'];
            print('Search Results: $buildings');
          } else {
            // Handle error
            print('Error searching buildings: ${result.data['error']}');
          }
        } catch (error) {
          print('Error searching buildings: $error');
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFF9CF93),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      icon: Icon(Icons.search, color: Colors.black),
      label: Text(
        'Search',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for buildings...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        buildSearchBar(),
        SizedBox(height: 16.0),
        buildSearchButton(),
      ],
    );
  }
}
