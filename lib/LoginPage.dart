import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAD5B7), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/Group_2.png', // Update the path based on your project structure
                  width: 150.0, 
                  height: 150.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 40.0,
                  height: 1.25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Add logic for forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.59,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        letterSpacing: 0.08,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF9CF93),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Implement your sign-up logic here
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      iconSize: 40.0,
                      splashRadius: 35.0,
                      padding: EdgeInsets.all(0.0),
                      alignment: Alignment.center,
                      tooltip: 'Create Account',
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        // No navigation logic here
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.2,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // No navigation logic here
                      },
                      child: Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.59,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000),
                          letterSpacing: 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
