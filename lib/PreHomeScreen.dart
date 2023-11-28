import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/signin.dart';

class PreHomeScreen extends StatelessWidget {
  const PreHomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEAD5B7), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Group_2.png',
                  height: 120.0, // Adjust the height as needed
                  width: 120.0, // Adjust the width as needed
                ),
                SizedBox(height: 16.0), // Add some space between image and text
                Container(
                  child: Text(
                    'Aqary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Simplify real estate selling, purchasing, renting, and managing properties',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 32.0),
                RoundedButton(
                  text: 'Login',
                  color: Color(0xFFF9CF93),
                  width: 304.0,
                  height: 59.0,
                  onPressed: () {
                    // Navigate to SignInPage when the "Login" button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>MyHomePage(title: 'Login')),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                RoundedButton(
                  text: 'Sign Up',
                  color: Color(0xFFD9D9D9),
                  width: 304.0,
                  height: 59.0,
                  onPressed: () {
                    // Navigate to SignInPage when the "Sign Up" button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.width,
    required this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
