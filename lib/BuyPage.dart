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
  int piccurrentIndex = 0;
  late Future<Map<String, dynamic>> apartmentData;
  late GoogleMapController mapController;
  bool isFavorite = false; // Added favorite state


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

  Future<String?> fetchSellerEmail(String sellerId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch user data where uid matches the SellerId
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('uid', isEqualTo: sellerId)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Assuming uid is unique, so there should be only one document
        DocumentSnapshot userSnapshot = userQuery.docs.first;
        print('Seller email found: ${userSnapshot['email']}');
        return userSnapshot['email'];
      } else {
        print('Seller not found in the user table.');
        return null;
      }
    } catch (e) {
      print('Error fetching seller email: $e');
      return null;
    }
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
        actions: [
            // Favorite Button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ],
        
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

            String apartmentType = apartmentData['Type'] ?? '';
            
            // Retrieve the list of image URLs
            List<String>? imageUrls = List<String>.from(apartmentData['Images']);

            return Stack(
              children: [
                Positioned.fill(
                  top: -190,
                  child: ClipRRect(
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: imageUrls.length,
                        controller: PageController(initialPage: 0),
                        onPageChanged: (picindex) {
                          setState(() {
                            piccurrentIndex = picindex;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrls[index]),
                                fit: BoxFit.fitWidth, 
                              ),
                            ),
                          );
                        },
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
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
                                  icon: Icons.bed,
                                  text: '${apartmentData['rooms']} Rooms',
                                ),
                                DetailContainerWithIcon(
                                  icon: Icons.bathtub,
                                  text:
                                      '${apartmentData['Bathrooms']} Bathroom',
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          String? sellerEmail =
                                              await fetchSellerEmail(
                                                  apartmentData['SellerId']);

                                          if (sellerEmail != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatPage1(
                                                  reciverUserEmail: sellerEmail,
                                                  reciverUserid:
                                                      apartmentData['SellerId'],
                                                ),
                                              ),
                                            );
                                          } else {
                                            print(
                                                'Error fetching seller email.');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFD6CBBB),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
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
                                if (apartmentType.toLowerCase() == 'rent')
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
                                            borderRadius:
                                                BorderRadius.circular(18),
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
                                            backgroundColor:
                                                const Color(0xFFD6CBBB),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
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
  
  // Definition of DetailContainerWithIcon widget
  Widget DetailContainerWithIcon({
    required IconData icon,
    required String text,
  }) {
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
