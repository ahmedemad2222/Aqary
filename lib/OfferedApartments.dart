import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    String loggedInUserId = _firebaseAuth.currentUser!.uid;

    QuerySnapshot querySnapshot =
        await buildings.where('SellerId', isEqualTo: loggedInUserId).get();

    apartments.clear();
    rentApartments.clear();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      data['documentId'] = document.id;

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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: active.length,
              itemBuilder: (context, index) {
                String name = active[index]['Name'];
                String price = 'Price: \$${active[index]['Price']}';
                int bathrooms = (active[index]['Bathrooms']);
                int bedrooms = (active[index]['rooms']);

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
                          bottom: 16), 
                      child: ApartmentWidget(
                        name: name,
                        price: price,
                        bathrooms: bathrooms,
                        bedrooms: bedrooms,
                      ),
                    ),
                  ),
                  onDismissed: (direction) async {
                    await showDeleteSnackbar(active[index]);
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

  Future<void> showDeleteSnackbar(Map<String, dynamic> apartment) async {
    final snackBar = SnackBar(
      content: Text('Apartment deleted'),
      duration: Duration(seconds: 8),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          undoDelete(apartment);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    await Future.delayed(Duration(seconds: 8));
    deleteApartment(apartment);
  }

  void undoDelete(Map<String, dynamic> apartment) {
    print('Undo delete for apartment: ${apartment["documentId"]}');
  }

  void deleteApartment(Map<String, dynamic> apartment) async {
    await FirebaseFirestore.instance
        .collection("Buildings")
        .doc(apartment["documentId"])
        .delete();
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = category == (_rentBuyIndex == 0 ? 'Rent' : 'Buy');

    return GestureDetector(
      onTap: () {
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