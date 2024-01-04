/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart' as NavBar;

class OfferedApartments extends StatefulWidget {
  const OfferedApartments({super.key});

  @override
  State<OfferedApartments> createState() => _OfferedApartmentsState();
}

class _OfferedApartmentsState extends State<OfferedApartments> {
  int _mainNavigationBarIndex = 0;
  int _rentBuyIndex = 0;

  List<Map<String, dynamic>> apartments = [];
  List<String> _selectedLocations = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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

      // Check if the type matches the selected category and the location matches
      if ((_rentBuyIndex == 0 && data['Type'] == 'Rent' ||
              _rentBuyIndex == 1 && data['Type'] == 'Sell') &&
          (_selectedLocations.isEmpty ||
              _selectedLocations.contains(data['Location']))) {
        apartments.add(data);
      }
    });
    setState(() {});


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

                // Get the building ID from the document ID
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
                      //_buildRecentLocation('Maadi'),
                      //_buildRecentLocation('Obour'),
                      //_buildRecentLocation('Aswan'),
                      //_buildRecentLocation('Alex'),
                      //_buildRecentLocation('Tagamoa'),
                      //_buildRecentLocation('Madint Nast'),
                      //_buildRecentLocation('Masr Algededa'),
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
            if (_selectedLocations.contains(location)) {
              _selectedLocations.remove(location); // Unselect the location
            } else {
              _selectedLocations.add(location);
            }
            fetchData(); // Call fetchData when the location changes
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart' as NavBar;

class OfferedApartments extends StatefulWidget {
  const OfferedApartments({Key? key}) : super(key: key);

  @override
  State<OfferedApartments> createState() => _OfferedApartmentsState();
}

class _OfferedApartmentsState extends State<OfferedApartments> {
  int _mainNavigationBarIndex = 0;
  int _rentBuyIndex = 0;
  List<Map<String, dynamic>> apartments = [];
  List<Map<String, dynamic>> rentApartments = [];
  List<Map<String, dynamic>> active = [];
  List<String> _selectedLocations = [];
  bool _isLocationExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    active = rentApartments;
  }

  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference buildings = firestore.collection('Buildings');

    QuerySnapshot querySnapshot = await buildings
        .where('SellerId', isEqualTo: 'uid')
        .get();

    // Clear the existing data before adding new data
    //apartments.clear();

    // Iterate through the documents and add them to the list
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Add the document ID to the data
      data['documentId'] = document.id;

      // Check if the type matches the selected category and the location matches
      if (data["Type"] == "Rent") {
        rentApartments.add(data);
      } else {
        apartments.add(data);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Apartments'),
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
              itemCount: active.length,
              itemBuilder: (context, index) {
                // Extract data from the list
                String name = active[index]['Name'];
                String price = 'Price: \$${active[index]['Price']}';
                int bathrooms = (active[index]['Bathrooms']);
                int bedrooms = (active[index]['rooms']);

                // Get the building ID from the document ID
                return Dismissible(
                  key: Key(active[index]["documentId"]),
                  direction: DismissDirection.horizontal,
                  child: GestureDetector(
                    onTap: () {
                      String buildingId = active[index]['documentId'];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuyPage(apartmentId: buildingId),
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
                  ),
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance.collection("Buildings").doc(active[index]["documentId"]).delete();
                  },
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

  Widget _buildRecentLocation(String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Handle recent location click
          print('Recent Location: $location clicked');
          setState(() {
            if (_selectedLocations.contains(location)) {
              _selectedLocations.remove(location); // Unselect the location
            } else {
              _selectedLocations.add(location);
            }
            fetchData(); // Call fetchData when the location changes
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
        // Handle category button click
        print('Category: $category clicked');
        setState(() {
          _rentBuyIndex = category == 'Rent' ? 0 : 1;
          if (_rentBuyIndex == 0) {
            active = rentApartments;
          } else {
            active = apartments;
          }
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
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(name),
        subtitle: Text('$bedrooms bedrooms | $bathrooms bathrooms\n$price'),
      ),
    );
  }
}

class BuyPage extends StatelessWidget {
  final String apartmentId;

  BuyPage({required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    // Implement the BuyPage widget
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Text('Details of apartment with ID: $apartmentId'),
      ),
    );
  }
}
