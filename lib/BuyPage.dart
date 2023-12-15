import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPage createState() => _BuyPage();
}

class _BuyPage extends State<BuyPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Apartment Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // This will navigate back to the previous screen.
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Container(
                width: 360,
                height: double.infinity,
                decoration: ShapeDecoration(
                  color: Color(0xFFF9CF93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(53),
                      topRight: Radius.circular(53),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo Area with rounded corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/house.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Apartment ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF404040),
                                    ),
                                  ),
                                  SizedBox(width: 130), // Added space
                                  Text(
                                    '3,000,000 LE',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF404040),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20), // Added space
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Color(0xFF404040),
                                  ),
                                  Text(
                                    'Nasr City, Makram Abeed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF404040),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5th Floor, 3 Rooms, 360 Sqft',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF404040),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '2 Bathrooms, ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF404040),
                            ),
                          ),
                          Text(
                            'Negotiable',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF404040),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Row for details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailContainer('3 Rooms'),
                          DetailContainer('2 Bathrooms'),
                          DetailContainer('Parking'),
                          DetailContainer('1 Kitchen'),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Row for icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.chat,
                            size: 30,
                            color: Color(0xFF404040),
                          ),
                          Container(
                            width: 360 - 16 * 2 - 8 * 2,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: Color(0xFFD6CBBB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to Chat Page or open Chat Functionality
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFD6CBBB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                'Contact Seller',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// Detail container widget
class DetailContainer extends StatelessWidget {
  final String detail;

  DetailContainer(this.detail);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71,
      height: 93,
      decoration: ShapeDecoration(
        color: Color(0xFFD6CBBB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Center(
        child: Text(
          detail,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF404040),
          ),
        ),
      ),
    );
  }
}
