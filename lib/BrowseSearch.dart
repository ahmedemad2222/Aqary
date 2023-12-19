import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/BuyPage.dart';
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

class BrowseSearch extends StatefulWidget {
  final String rentBuyOption;
  final int selectedBedrooms;
  final int selectedBathrooms;
  final String searchQuery;

  BrowseSearch({
    required this.rentBuyOption,
    required this.selectedBedrooms,
    required this.selectedBathrooms,
    required this.searchQuery,
  });

  @override
  _BrowseSearchState createState() => _BrowseSearchState();
}

class _BrowseSearchState extends State<BrowseSearch> {
  int _mainNavigationBarIndex = 0;

  // List to store fetched data from Firebase
  List<Map<String, dynamic>> apartments = [];

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

      // Add the document ID to the data
      data['documentId'] = document.id;

      // Check if the type matches the selected category ("Rent" or "Buy") and the location matches
      if ((widget.rentBuyOption == 'Rent' && data['Type'] == 'Rent' ||
              widget.rentBuyOption == 'Sell' && data['Type'] == 'Sell') &&
          (widget.selectedBedrooms == 0 ||
              data['rooms'] == widget.selectedBedrooms) &&
          (widget.selectedBathrooms == 0 ||
              data['Bathrooms'] == widget.selectedBathrooms) &&
          (widget.searchQuery.isEmpty ||
              data['PropertyType'] == widget.searchQuery)) {
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
                    padding: EdgeInsets.only(
                        bottom: 16), // Adjust the bottom padding as needed
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
}
