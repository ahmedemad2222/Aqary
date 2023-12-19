import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/ChatPage1.dart';
import 'package:flutter_application_1/ChoosePaymentPage.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPage extends StatefulWidget {
  final String apartmentId;

  const BuyPage({Key? key, required this.apartmentId}) : super(key: key);

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
    apartmentData = fetchApartmentData();
  }

  Future<Map<String, dynamic>> fetchApartmentData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Buildings').doc(widget.apartmentId).get();

    return documentSnapshot.data() as Map<String, dynamic>;
  }

  Future<void> _openGoogleMaps(String location) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';

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
          title: const Text('Apartment Details'),
          backgroundColor: const Color.fromARGB(255, 227, 183, 121),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: apartmentData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data found'));
            }

            Map<String, dynamic> apartmentData = snapshot.data!;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/buypage.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 285,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 145,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        color: Color(0xFFF9CF93),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF404040),
                                          ),
                                        ),
                                        const SizedBox(width: 170),
                                        Text(
                                          'Price: ${apartmentData['Price'] ?? 'N/A'} \$',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF404040),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Color(0xFF404040),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            String location =
                                                apartmentData['Location'] ??
                                                    'Unknown';
                                            _openGoogleMaps(location);
                                          },
                                          child: Text(
                                            'Location: ${apartmentData['Location'] ?? 'Unknown'}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Description: ${apartmentData['Description']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF404040),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailContainerWithIcon(
                                  icon: Icons.room,
                                  text: '${apartmentData['rooms']} Rooms',
                                ),
                                DetailContainerWithIcon(
                                  icon: Icons.bathtub,
                                  text: '${apartmentData['Bathrooms']} Bathroom',
                                ),
                                DetailContainerWithIcon(
                                  icon: Icons.pool,
                                  text: 'Pool ${apartmentData['Pool']}',
                                ),
                                DetailContainerWithIcon(
                                  icon: Icons.kitchen,
                                  text: '${apartmentData['Kitchens']} Kitchen',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.chat,
                                      size: 30,
                                      color: Color(0xFF404040),
                                    ),
                                    const SizedBox(width: 25),
                                    Container(
                                      width: 360 - 16 * 2 - 8 * 2,
                                      height: 45,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFD6CBBB),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage1(
                                                reciverUserEmail: apartmentData['SellerId'],
                                                reciverUserid: apartmentData['SellerId'],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFD6CBBB),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: const Text(
                                          'Contact Seller',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.payment,
                                      size: 30,
                                      color: Color(0xFF404040),
                                    ),
                                    const SizedBox(width: 25),
                                    Container(
                                      width: 360 - 16 * 2 - 8 * 2,
                                      height: 45,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFD6CBBB),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChoosePaymentPage(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFD6CBBB),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: const Text(
                                          'Choose Payment',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
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

class DetailContainerWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailContainerWithIcon({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71,
      height: 93,
      decoration: ShapeDecoration(
        color: const Color(0xFFD6CBBB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF404040),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF404040),
            ),
          ),
        ],
      ),
    );
  }
}
