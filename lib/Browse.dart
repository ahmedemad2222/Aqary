import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/BuyPage.dart';
import 'package:flutter_application_1/NavBar.dart' as NavBar;

class ApartmentWidget extends StatelessWidget {
  final String name;
  final String price;
  final int bathrooms;
  final int bedrooms;

  ApartmentWidget({
    required this.name,
    required this.price,
    required this.bathrooms,
    required this.bedrooms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              price,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.bathtub),
                SizedBox(width: 4),
                Text('Bathrooms: $bathrooms'),
                SizedBox(width: 16),
                Icon(Icons.king_bed),
                SizedBox(width: 4),
                Text('Bedrooms: $bedrooms'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BrowsePage extends StatefulWidget {
  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  int _mainNavigationBarIndex = 0;
  int _rentBuyIndex = 0;

  bool _isLocationExpanded = false;

  List<Map<String, dynamic>> apartments = [];
  List<String> _selectedLocations = [];
  String? _loggedInUserId;

  @override
  void initState() {
    super.initState();
    _getLoggedInUserId();
    fetchData();
  }

  Future<void> _getLoggedInUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUserId = user.uid;
    }
  }

  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference buildings = firestore.collection('Buildings');

    QuerySnapshot querySnapshot = await buildings.get();

    apartments.clear();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      data['documentId'] = document.id;

      if ((_rentBuyIndex == 0 && data['Type'] == 'Rent' ||
              _rentBuyIndex == 1 && data['Type'] == 'Sell') &&
          (_selectedLocations.isEmpty ||
              _selectedLocations.contains(data['Location'])) &&
          (_loggedInUserId == null || data['SellerId'] != _loggedInUserId)) {
        apartments.add(data);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton('Rent'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('|', style: TextStyle(fontSize: 20)),
                ),
                _buildCategoryButton('Buy'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                String name = apartments[index]['Name'];
                String price = 'Price: \$${apartments[index]['Price']}';
                int bathrooms = (apartments[index]['Bathrooms']);
                int bedrooms = (apartments[index]['rooms']);

                return GestureDetector(
                  onTap: () {
                    String buildingId = apartments[index]['documentId'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyPage(apartmentId: buildingId),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ApartmentWidget(
                      name: name,
                      price: price,
                      bathrooms: bathrooms,
                      bedrooms: bedrooms,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF9CF93),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(31),
                topRight: Radius.circular(31),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLocationExpanded = !_isLocationExpanded;
                    });
                  },
                  child: Text(
                    _isLocationExpanded
                        ? _selectedLocations.isEmpty
                            ? 'Select Locations'
                            : _selectedLocations.join(', ')
                        : 'Select Locations',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 16),
                if (_isLocationExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recents:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      _buildRecentLocation('Maadi'),
                      _buildRecentLocation('Obour'),
                      _buildRecentLocation('Aswan'),
                      _buildRecentLocation('Alex'),
                      _buildRecentLocation('Tagamoa'),
                      _buildRecentLocation('Madint Nast'),
                      _buildRecentLocation('Masr Algededa'),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar.CustomBottomNavigationBar(
        currentIndex: _mainNavigationBarIndex,
        onTap: (index) {
          setState(() {
            _mainNavigationBarIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildRecentLocation(String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          print('Recent Location: $location clicked');
          setState(() {
            if (_selectedLocations.contains(location)) {
              _selectedLocations.remove(location);
            } else {
              _selectedLocations.add(location);
            }
            fetchData();
          });
        },
        child: Text(
          location,
          style: TextStyle(
            fontSize: 14,
            color: _selectedLocations.contains(location)
                ? Colors.blue
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = category == (_rentBuyIndex == 0 ? 'Rent' : 'Buy');

    return GestureDetector(
      onTap: () {
        print('Category: $category clicked');
        setState(() {
          _rentBuyIndex = category == 'Rent' ? 0 : 1;
          fetchData();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Color(0xFFF9CF93) : null,
        ),
        child: Text(
          category,
          style:
              TextStyle(fontSize: 16, color: isSelected ? Colors.black : null),
        ),
      ),
    );
  }
}
