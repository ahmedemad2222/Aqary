import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/PreHomeScreen.dart';

class ItemAdded extends StatefulWidget {
  const ItemAdded({super.key});

  @override
  State<ItemAdded> createState() => _ItemAddedState();
}

class _ItemAddedState extends State<ItemAdded> {
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAD5B7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: 400,
              child: Image.asset('assets/Confirmed.png'),
            ),
            Container(
              child: Text(
                'Ad published successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Set the color to green
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
