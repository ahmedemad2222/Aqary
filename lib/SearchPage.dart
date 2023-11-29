import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          backgroundColor: Color(0xFFF9CF93),
        ),
        body: SearchContent(),
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
  String selectedOption = 'Rent';
  int selectedRooms = 1;
  int selectedToilets = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/search_img.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20.0,
                left: 16.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Handle back button press
                  },
                ),
              ),
              Positioned(
                top: 80.0,
                left: 16.0,
                child: Text(
                  'Find your dream home with\nAQARY smart search',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildOptionButton('Rent'),
                      buildSeparator(),
                      buildOptionButton('Buy'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  buildSearchBar(),
                  SizedBox(height: 16.0),
                  selectedOption == 'Rent'
                      ? buildRentOptions()
                      : buildBuyOptions(),
                  SizedBox(height: 16.0),
                  buildSearchButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOptionButton(String option) {
    return Container(
      width: 120.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: selectedOption == option ? Color(0xFFF9CF93) : Colors.white,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedOption = option;
            });
          },
          onHover: (isHovered) {
            // Handle hover effect
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center,
            child: Text(
              option,
              style: TextStyle(
                color: selectedOption == option ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeparator() {
    return Container(
      width: 20.0,
      alignment: Alignment.center,
      child: Text(
        '|',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildRentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        Text('Number of Rooms: $selectedRooms'),
        SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildRoomButton(1),
              buildRoomButton(2),
              buildRoomButton(3),
              buildRoomButton(4),
              buildRoomButton(5, isPlus: true),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Text('Number of Toilets: $selectedToilets'),
        SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildToiletButton(1),
              buildToiletButton(2),
              buildToiletButton(3),
              buildToiletButton(4),
              buildToiletButton(5, isPlus: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBuyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        Text('Number of Rooms: $selectedRooms'),
        SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildRoomButton(1),
              buildRoomButton(2),
              buildRoomButton(3),
              buildRoomButton(4),
              buildRoomButton(5, isPlus: true),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Text('Number of Toilets: $selectedToilets'),
        SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildToiletButton(1),
              buildToiletButton(2),
              buildToiletButton(3),
              buildToiletButton(4),
              buildToiletButton(5, isPlus: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRoomButton(int count, {bool isPlus = false}) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          selectedRooms = isPlus ? 5 : count;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedRooms == (isPlus ? 5 : count)
            ? Color(0xFFF9CF93)
            : Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      icon: Icon(Icons.king_bed, color: Colors.black),
      label: Text(
        isPlus ? '5+' : '$count',
        style: TextStyle(
          color: selectedRooms == (isPlus ? 5 : count)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Widget buildToiletButton(int count, {bool isPlus = false}) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          selectedToilets = isPlus ? 5 : count;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedToilets == (isPlus ? 5 : count)
            ? Color(0xFFF9CF93)
            : Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      icon: Icon(Icons.bathtub, color: Colors.black),
      label: Text(
        isPlus ? '5+' : '$count',
        style: TextStyle(
          color: selectedToilets == (isPlus ? 5 : count)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Widget buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle search button press
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
                hintText: 'Search for locations...',
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
}
