import 'package:flutter/material.dart';
import 'package:flutter_application_1/PaymentSuccess.dart';

class VisaPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Payment'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Stack(
        children: [
          // Container with card input fields
          Positioned.fill(
            top: MediaQuery.of(context).size.height / 4.7,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF9CF93),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCardInput('Card Number', 'F0F2F8'),
                    SizedBox(height: 16),
                    _buildExpiryDateInput('Expiry Date', 'F0F2F8'),
                    SizedBox(height: 16),
                    _buildCardInput('CVV', 'F0F2F8'),
                    SizedBox(height: 16),
                    _buildCardInput('Card Holder Name', 'F0F2F8'),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the PaymentSuccessPage on button press
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentSuccessPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF4F4F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Pay Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Image in front of the container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Visa.png', // Replace with the actual image path
              height: MediaQuery.of(context).size.height / 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInput(String labelText, String buttonColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF$buttonColor')),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpiryDateInput(String labelText, String buttonColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF$buttonColor')),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF$buttonColor')),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
