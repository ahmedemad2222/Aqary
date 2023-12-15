import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart';

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
  int _currentIndex = 0;
  bool _isLocationExpanded = false;

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
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ApartmentWidget(name: 'Apartment 1', price: 'Price: \$1000', bathrooms: 2, bedrooms: 1),
                SizedBox(height: 16),
                ApartmentWidget(name: 'Apartment 2', price: 'Price: \$1200', bathrooms: 3, bedrooms: 2),
                SizedBox(height: 16),
                ApartmentWidget(name: 'Apartment 3', price: 'Price: \$1250', bathrooms: 3, bedrooms: 2),
                SizedBox(height: 16),
                ApartmentWidget(name: 'Apartment 4', price: 'Price: \$1500', bathrooms: 3, bedrooms: 2),
              ],
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
                    _isLocationExpanded ? 'Cairo, Egypt' : 'Cairo',
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
                      _buildRecentLocation('Maadi, Cairo, Egypt'),
                      _buildRecentLocation('Another Location'),
                      _buildRecentLocation('Yet Another Location'),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
        },
        child: Text(
          location,
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = category == (_currentIndex == 0 ? 'Rent' : 'Buy');

    return GestureDetector(
      onTap: () {
        // Handle category button click
        print('Category: $category clicked');
        setState(() {
          _currentIndex = category == 'Rent' ? 0 : 1;
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

  BottomNavigationBarItem buildBottomNavigationBarItem(
    IconData icon, String label, int index,
  ) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          if (index == _currentIndex)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(249, 207, 147, 1),
                ),
                child: Text(''),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
