import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/NavBar.dart' as NavBar;
import 'package:flutter_application_1/SearchPage.dart';

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

  // List to store fetched data from Firebase
  List<Map<String, dynamic>> apartments = [];

  String _selectedLocation = ''; // Store the selected location

  @override
  void initState() {
    super.initState();
    // Call the function to fetch data when the widget is first initialized
    fetchData();
  }

  // Function to fetch data from Firebase
  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference buildings = firestore.collection('Buildings');

    QuerySnapshot querySnapshot = await buildings.get();

    // Clear the existing data before adding new data
    apartments.clear();

    // Iterate through the documents and add them to the list
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Check if the type matches the selected category ("Rent" or "Buy") and the location matches
      if ((_rentBuyIndex == 0 && data['Type'] == 'Rent' || _rentBuyIndex == 1 && data['Type'] == 'Sell') &&
          (_selectedLocation.isEmpty || data['Location'] == _selectedLocation)) {
        apartments.add(data);
      }
    });

    // Update the state to trigger a rebuild of the UI
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
          // Small Navigation Bar (Rent and Buy)
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

          // Main Content (Apartments)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                // Extract data from the list
                String name = apartments[index]['Name'];
                String price = 'Price: \$${apartments[index]['Price']}';
                int bathrooms = (apartments[index]['Bathrooms']);
                int bedrooms = (apartments[index]['rooms']);

                // Return ApartmentWidget with fetched data
                return Padding(
                  padding: EdgeInsets.only(bottom: 16), // Adjust the bottom padding as needed
                  child: ApartmentWidget(
                    name: name,
                    price: price,
                    bathrooms: bathrooms,
                    bedrooms: bedrooms,
                  ),
                );
              },
            ),
          ),

          // Location and Recents
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
                    _isLocationExpanded ? 'Egypt' : 'Egypt',
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          // Handle recent location click
          print('Recent Location: $location clicked');
          setState(() {
            _selectedLocation = location;
            fetchData(); // Call fetchData when the location changes
          });
        },
        child: Text(
          location,
          style: TextStyle(fontSize: 14, color: _selectedLocation == location ? Colors.blue : Colors.black),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = category == (_rentBuyIndex == 0 ? 'Rent' : 'Buy');

    return GestureDetector(
      onTap: () {
        // Handle category button click
        print('Category: $category clicked');
        setState(() {
          _rentBuyIndex = category == 'Rent' ? 0 : 1;
          fetchData(); // Call fetchData when the category changes
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
          style: TextStyle(fontSize: 16, color: isSelected ? Colors.black : null),
        ),
      ),
    );
  }
}
