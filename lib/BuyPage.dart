import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPage extends StatefulWidget {
  final String apartmentId;

  BuyPage({required this.apartmentId});

  @override
  _BuyPage createState() => _BuyPage();
}

class _BuyPage extends State<BuyPage> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> apartmentData;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch apartment data when the widget is first initialized
    apartmentData = fetchApartmentData();
  }

  Future<Map<String, dynamic>> fetchApartmentData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Buildings').doc(widget.apartmentId).get();

    // Store the apartment data
    return documentSnapshot.data() as Map<String, dynamic>;
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      print('Could not open Google Maps.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Apartment Details'),
          backgroundColor: Color.fromARGB(255, 227, 183, 121),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: apartmentData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found'));
            }

            Map<String, dynamic> apartmentData = snapshot.data!;

            return Stack(
              children: [
                // Image above details container
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/buypage.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 185,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
                      height: 145,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        color: Color(
                            0xFFF9CF93), // Background color for details container
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          apartmentData['Name'],
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF404040),
                                          ),
                                        ),
                                        SizedBox(width: 130),
                                        Text(
                                          'Price: ${apartmentData['Price'] ?? 'N/A'} LE',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF404040),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Color(0xFF404040),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Handle the click on the location here
                                            double latitude = 40.689247; // Replace with the actual latitude key
                                            double longitude = -74.044502; // Replace with the actual longitude key
                                            _openGoogleMaps(latitude, longitude);
                                          },
                                          child: Text(
                                            'Location: ${apartmentData['Location'] ?? 'Unknown'}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                            ),
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
                              'Description: ${apartmentData['Description']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF404040),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailContainer('${apartmentData['rooms']} Rooms'),
                                DetailContainer('${apartmentData['Bathrooms']} Bathrooms'),
                                DetailContainer('${apartmentData['Parking']} Parking'),
                                DetailContainer('${apartmentData['Kitchens']} Kitchen'),
                              ],
                            ),
                            SizedBox(height: 16),
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
                ),
              ],
            );
          },
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
