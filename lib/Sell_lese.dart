import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/ItemAdded.dart';

class Sell_lese extends StatefulWidget {
  @override
  _Sell_leseState createState() => _Sell_leseState();
}

class _Sell_leseState extends State<Sell_lese> {
  int currentStep = 0;

  // Form controllers for text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String type = "Sell";
  String Number_of_rooms = "1";
  String Number_of_Bathrooms = "1";
  String Number_of_Kitchens = "1";
  String Has_a_Parking = "No";
  String Has_a_Pool = "No";
  String Building_Type = "Apartment";

  void handleContinueButtonPressed() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userID;

    if (user != null && user.uid.isNotEmpty) {
      userID = user.uid;
    } else {
      // Handle the case where the user is not logged in
      print('User not logged in.');
      return;
    }

    await PublishAd().publishAd(
      userID,
      type,
      titleController.text,
      descriptionController.text,
      int.parse(Number_of_rooms),
      int.parse(Number_of_Bathrooms),
      int.parse(Number_of_Kitchens),
      Has_a_Parking == 'Yes',
      Has_a_Pool == 'Yes',
      Building_Type,
      locationController.text,
      int.parse(priceController.text),
    );

    // After publishing the ad, navigate to another page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemAdded(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey
            .withOpacity(1), // Set the background color with transparency

        // Other properties of the AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/search_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Find a renter or buyer with Aqary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: BoxDecoration(
              color: Color(0xFFF9CF93),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stepper(
              currentStep: currentStep,
              onStepContinue: () {
                if (currentStep < 2) {
                  setState(() {
                    currentStep += 1;
                  });
                } else {
                  handleContinueButtonPressed();
                }
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep -= 1;
                  });
                } else {
                  // Handle the first step or perform any cancel actions.
                  // For example, you may want to close the stepper.
                }
              },
              steps: [
                Step(
                  title: Text('Step 1'),
                  content: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('List property for:'),
                        Row(
                          children: [
                            Radio(
                              value: 'Sell',
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value.toString();
                                });
                              },
                            ),
                            Text('Sell'),
                            SizedBox(width: 10),
                            Radio(
                              value: 'Rent',
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value.toString();
                                });
                              },
                            ),
                            Text('Rent'),
                          ],
                        ),
                        Text('Add posting title:'),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFEF4E7),
                          ),
                        ),
                        Text('Describe the property:'),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFEF4E7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text('Step 2'),
                  content: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rooms:'),
                        Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i.toString(),
                                    groupValue: Number_of_rooms,
                                    onChanged: (value) {
                                      setState(() {
                                        Number_of_rooms = value.toString();
                                      });
                                    },
                                  ),
                                  Text(i.toString()),
                                ],
                              ),
                          ],
                        ),
                        Text('Bathrooms:'),
                        Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i.toString(),
                                    groupValue: Number_of_Bathrooms,
                                    onChanged: (value) {
                                      setState(() {
                                        Number_of_Bathrooms = value.toString();
                                      });
                                    },
                                  ),
                                  Text(i.toString()),
                                ],
                              ),
                          ],
                        ),
                        Text('Kitchens:'),
                        Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i.toString(),
                                    groupValue: Number_of_Kitchens,
                                    onChanged: (value) {
                                      setState(() {
                                        Number_of_Kitchens = value.toString();
                                      });
                                    },
                                  ),
                                  Text(i.toString()),
                                ],
                              ),
                          ],
                        ),
                        Text('Parking:'),
                        Row(
                          children: [
                            Radio(
                              value: 'Yes',
                              groupValue: Has_a_Parking,
                              onChanged: (value) {
                                setState(() {
                                  Has_a_Parking = value.toString();
                                });
                              },
                            ),
                            Text('Yes'),
                            SizedBox(width: 10),
                            Radio(
                              value: 'No',
                              groupValue: Has_a_Parking,
                              onChanged: (value) {
                                setState(() {
                                  Has_a_Parking = value.toString();
                                });
                              },
                            ),
                            Text('No'),
                          ],
                        ),
                        Text('Pool:'),
                        Row(
                          children: [
                            Radio(
                              value: 'Yes',
                              groupValue: Has_a_Pool,
                              onChanged: (value) {
                                setState(() {
                                  Has_a_Pool = value.toString();
                                });
                              },
                            ),
                            Text('Yes'),
                            SizedBox(width: 10),
                            Radio(
                              value: 'No',
                              groupValue: Has_a_Pool,
                              onChanged: (value) {
                                setState(() {
                                  Has_a_Pool = value.toString();
                                });
                              },
                            ),
                            Text('No'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text('Step 3'),
                  content: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type:'),
                        Row(
                          children: [
                            Radio(
                              value: 'Apartment',
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value.toString();
                                });
                              },
                            ),
                            Text('Apartment'),
                            SizedBox(width: 10),
                            Radio(
                              value: 'Villa',
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value.toString();
                                });
                              },
                            ),
                            Text('Villa'),

                            Radio(
                              value: 'Compound',
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value.toString();
                                });
                              },
                            ),
                            Text('Compound'),
                            // Add more radio buttons as needed
                          ],
                        ),
                        Text('Location:'),
                        TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFEF4E7),
                          ),
                        ),
                        Text('Price:'),
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFEF4E7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PublishAd {
  Future<void> publishAd(
    String UserID,
    String listingType,
    String title,
    String description,
    int rooms,
    int bathrooms,
    int kitchens,
    bool parking,
    bool pool,
    String propertyType,
    String location,
    int price,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference buildings = firestore.collection('Buildings');

    await buildings.add({
      'SellerId': UserID,
      'Type': listingType,
      'Name': title,
      'Description': description,
      'rooms': rooms,
      'Bathrooms': bathrooms,
      'Kitchens': kitchens,
      'Parking': parking,
      'Pool': pool,
      'PropertyType': propertyType,
      'Location': location,
      'Price': price,
    });

    print('Ad published to Firestore!');
  }
}
