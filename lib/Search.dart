import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Browse.dart';
import 'package:flutter_application_1/BrowseSearch.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/Test2.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int currentIndex = 0;
  String Building_Type = "Villa";
  int selectedBedrooms = 1;
  int selectedBathrooms = 1;
  List<Map<String, dynamic>> apartments = [];
  String _rentBuyIndex = "Rent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/search_img.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      'Find your dream home with Aqary ',
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
                height: MediaQuery.of(context).size.height / 1.75,
                decoration: BoxDecoration(
                  color: Color(0xFFF9CF93),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Replaced ElevatedButtons with RadioButtons

                            Radio(
                              value: "Rent",
                              groupValue: _rentBuyIndex,
                              onChanged: (value) {
                                setState(() {
                                  _rentBuyIndex = value as String;
                                });
                              },
                              activeColor: Color(0xFFF9CF93),
                            ),
                            Text('Rent'),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Radio(
                              value: "Sell",
                              groupValue: _rentBuyIndex,
                              onChanged: (value) {
                                setState(() {
                                  _rentBuyIndex = value as String;
                                });
                              },
                              activeColor: Color(0xFFF9CF93),
                            ),
                            Text('Buy'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home),
                            Radio(
                              value: "Villa",
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value as String;
                                });
                              },
                              activeColor: Color(0xFFF9CF93),
                            ),
                            Text('Villa'),
                            SizedBox(width: 20),
                            Radio(
                              value: "Apartment",
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value as String;
                                });
                              },
                              activeColor: Color(0xFFF9CF93),
                            ),
                            Text('Apartment'),
                            SizedBox(width: 20),
                            Radio(
                              value: "Compound",
                              groupValue: Building_Type,
                              onChanged: (value) {
                                setState(() {
                                  Building_Type = value as String;
                                });
                              },
                              activeColor: Color(0xFFF9CF93),
                            ),
                            Text('Compound'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bed),
                            SizedBox(width: 10),
                            // Replaced GestureDetector and Container with RadioButtons
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedBedrooms,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBedrooms = value as int;
                                      });
                                    },
                                    activeColor: Color(0xFFF9CF93),
                                  ),
                                  Text('$i'),
                                ],
                              ),
                            Row(
                              children: [
                                Radio(
                                  value: 5 + 1,
                                  groupValue: selectedBedrooms,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBedrooms = value as int;
                                    });
                                  },
                                  activeColor: Color(0xFFF9CF93),
                                ),
                                Text('5+'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bathtub),
                            SizedBox(width: 10),
                            // Replaced GestureDetector and Container with RadioButtons
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedBathrooms,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBathrooms = value as int;
                                      });
                                    },
                                    activeColor: Color(0xFFF9CF93),
                                  ),
                                  Text('$i'),
                                ],
                              ),
                            Row(
                              children: [
                                Radio(
                                  value: 5 + 1,
                                  groupValue: selectedBathrooms,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBathrooms = value as int;
                                    });
                                  },
                                  activeColor: Color(0xFFF9CF93),
                                ),
                                Text('5+'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrowseSearch(
                                  rentBuyOption: _rentBuyIndex,
                                  selectedBedrooms: selectedBedrooms,
                                  selectedBathrooms: selectedBathrooms,
                                  searchQuery: Building_Type,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFF9CF93),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
    );
  }
}
