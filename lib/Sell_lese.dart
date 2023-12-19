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

  StepState getStepState(int step) {
    if (currentStep > step) {
      return StepState.complete;
    } else if (currentStep == step) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }

  void handleContinueButtonPressed() {
    bool isValid = false;

    // Check if the required fields for the current step are filled
    switch (currentStep) {
      case 0:
        isValid = titleController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty;
        break;
      case 1:
        isValid = Number_of_rooms.isNotEmpty &&
            Number_of_Bathrooms.isNotEmpty &&
            Number_of_Kitchens.isNotEmpty &&
            Has_a_Parking.isNotEmpty &&
            Has_a_Pool.isNotEmpty;
        break;
      case 2:
        isValid = Building_Type.isNotEmpty &&
            locationController.text.isNotEmpty &&
            priceController.text.isNotEmpty;
        break;
      default:
        isValid = false;
    }
    User? user = FirebaseAuth.instance.currentUser;
    String? userID;

    if (user != null && user.uid.isNotEmpty) {
      userID = user.uid;
    } else {
      // Handle the case where the user is not logged in
      print('User not logged in.');
      return;
    }

    if (isValid) {
      setState(() {
        if (currentStep < 2) {
          currentStep += 1;
        } else {
          // Your existing logic for handling the final step
          PublishAd().publishAd(
            userID!,
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
      });
    } else {
      // Highlight the step in red by updating the Stepper
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields in the current step.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Lese'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/search_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            left: 48,
            child: Text(
              'Find a renter or buyer with Aqary',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // fontFamily: 'YourFontFamily',
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height / 2.6,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF9CF93),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stepper(
                currentStep: currentStep,
                onStepContinue: handleContinueButtonPressed,
                onStepCancel: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  } else {
                    // Handle the first step or perform any cancel actions.
                  }
                },
                steps: [
                  Step(
                    state: getStepState(0),
                    title: Text(
                      'Step 1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'List property for:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                              SizedBox(width: 5),
                              Text('Sell'),
                              SizedBox(width: 20),
                              Radio(
                                value: 'Rent',
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value.toString();
                                  });
                                },
                              ),
                              SizedBox(width: 5),
                              Text('Rent'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add posting title:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          RoundedTextField(titleController),
                          SizedBox(height: 10),
                          Text(
                            'Describe the property:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          RoundedTextField(descriptionController),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    state: getStepState(1),
                    title: Text(
                      'Step 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rooms:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                                    SizedBox(width: 10),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Bathrooms:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                                          Number_of_Bathrooms =
                                              value.toString();
                                        });
                                      },
                                    ),
                                    Text(i.toString()),
                                    SizedBox(width: 10),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Kitchens:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                                    SizedBox(width: 10),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Parking:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                              SizedBox(width: 5),
                              Text('Yes'),
                              SizedBox(width: 20),
                              Radio(
                                value: 'No',
                                groupValue: Has_a_Parking,
                                onChanged: (value) {
                                  setState(() {
                                    Has_a_Parking = value.toString();
                                  });
                                },
                              ),
                              SizedBox(width: 5),
                              Text('No'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Pool:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                              SizedBox(width: 5),
                              Text('Yes'),
                              SizedBox(width: 20),
                              Radio(
                                value: 'No',
                                groupValue: Has_a_Pool,
                                onChanged: (value) {
                                  setState(() {
                                    Has_a_Pool = value.toString();
                                  });
                                },
                              ),
                              SizedBox(width: 5),
                              Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    state: getStepState(2),
                    title: Text(
                      'Step 3',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                              SizedBox(width: 5),
                              Text('Apartment'),
                              SizedBox(width: 20),
                              Radio(
                                value: 'Villa',
                                groupValue: Building_Type,
                                onChanged: (value) {
                                  setState(() {
                                    Building_Type = value.toString();
                                  });
                                },
                              ),
                              SizedBox(width: 5),
                              Text('Villa'),
                              SizedBox(width: 20),
                              Radio(
                                value: 'Compound',
                                groupValue: Building_Type,
                                onChanged: (value) {
                                  setState(() {
                                    Building_Type = value.toString();
                                  });
                                },
                              ),
                              SizedBox(width: 5),
                              Text('Compound'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Location:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          RoundedTextField(locationController),
                          SizedBox(height: 10),
                          Text(
                            'Price:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          RoundedTextField(priceController),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Set the current index accordingly
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Add your logic for index 1 (Chat)
              break;
            case 2:
              // Add your logic for index 2 (Profile)
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;

  RoundedTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFFEF4E7),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter text',
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
        ),
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
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFD6CBBB),
      items: [
        buildBottomNavigationBarItem(Icons.home, 'Home', 0),
        buildBottomNavigationBarItem(Icons.chat, 'Chat', 1),
        buildBottomNavigationBarItem(Icons.person, 'Profile', 2),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
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
