import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aqary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'What are you looking for?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                      letterSpacing: 0.84,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search button tap
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Handle add button tap
                      },
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 155.0,
              padding: EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  InkWell(
                    onTap: () {
                      // Handle button tap for 'House'
                    },
                    child: CategoryButton(
                      category: 'House',
                      imageAsset: AssetImage('assets/house.png'),
                      results: '6,342 results',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle button tap for 'Apartments'
                    },
                    child: CategoryButton(
                      category: 'Apartments',
                      imageAsset: AssetImage('assets/Apartments.png'),
                      results: '14,521 results',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle button tap for 'Chalets'
                    },
                    child: CategoryButton(
                      category: 'Chalets',
                      imageAsset: AssetImage('assets/Chalets.png'),
                      results: '10,921 results',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle button tap for 'Compounds'
                    },
                    child: CategoryButton(
                      category: 'Compounds',
                      imageAsset: AssetImage('assets/Compounds.png'),
                      results: '8,361 results',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Add your main content here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD6CBBB),
        items: [
          buildBottomNavigationBarItem(Icons.home, 'Home', 0),
          buildBottomNavigationBarItem(Icons.chat, 'Chat', 1),
          buildBottomNavigationBarItem(Icons.person, 'Profile', 2),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          if (index == currentIndex)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9CF93),
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

class CategoryButton extends StatelessWidget {
  final String category;
  final ImageProvider imageAsset;
  final String results;

  CategoryButton({
    required this.category,
    required this.imageAsset,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 149.0, // Increased width to 149
          height: 155.0, // Increased height to 155
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: imageAsset,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          results,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
