import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart' as NavBar; // Use 'as' to provide an alias
import 'package:flutter_application_1/Search.dart';
import 'package:flutter_application_1/Sell_lese.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  int picindex = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (picindex < 3) {
        picindex++;
      } else {
        picindex = 0;
      }
      _pageController.animateToPage(
        picindex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqary'),
        backgroundColor: const Color.fromARGB(255, 227, 183, 121),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'What are you looking for?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                      letterSpacing: 0.84,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Search()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Sell_lese()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  kBottomNavigationBarHeight,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    picindex = index;
                  });
                },
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/apartment2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/apartment.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/apartment3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Add more containers with images as needed
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: NavBar.CustomBottomNavigationBar(
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
