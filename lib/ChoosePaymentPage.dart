import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomeScreen.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/Sell_lese.dart';
import 'package:flutter_application_1/Visa.dart';

class ChoosePaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Payment'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            buildRoundedButton('Visa', Color(0xFFF9CF93), () {
              // Handle Visa button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisaPaymentPage()),
              );
            }),
            SizedBox(height: 20),
            buildRoundedButton('Cash', Color.fromARGB(255, 174, 169, 161), () {
              // Handle Cash button press
            }),
            SizedBox(height: 20),
            Text(
              'Total Price',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              // Replace this with your actual total price logic
              '\$100.00',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            // Add cases for other navigation items if needed
          }
        },
      ),
    );
  }

  Widget buildRoundedButton(String label, Color backgroundColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
