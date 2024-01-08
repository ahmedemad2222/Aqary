import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/ImagePicker.dart';
import 'package:flutter_application_1/PreHomeScreen.dart';
import 'package:image_picker/image_picker.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<XFile> _images = [];

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void _navigateToImagePicker(BuildContext context) async {
    List<XFile>? selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImagePickerScreen(),
      ),
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        // Add the selected images to your existing list of images
        _images.addAll(selectedImages);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        print('Image picked: ${pickedFile.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

void _createAccount(BuildContext context) async {
  try {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: _emailController.text, password: _passwordController.text,
    );

    // Upload each image to Firestore and get the download URLs
    List<String> imageUrls = [];
    for (XFile image in _images) {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'Buildings/images/$fileName.jpg';

      // Upload file to Firestore
      Reference uploadRef = FirebaseStorage.instance.ref().child(filePath);
      await uploadRef.putFile(file);

      String downloadURL = await uploadRef.getDownloadURL();
      imageUrls.add(downloadURL);
    }

    // Save user data including image URLs in Firestore
    await _firestore.collection('users').doc(authResult.user!.uid).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'uid': authResult.user!.uid,
      'imageUrls': imageUrls,  // Add the image URLs to user data
      // Add other fields as needed
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => PreHomeScreen()));
  } catch (error) {
    print('Error creating account: $error');
    // Handle error here
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create An Account'),
        backgroundColor: Color.fromARGB(255, 227, 183, 121),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD6CBBB), Color(0xFFFAEEE0), Color(0xFFFFFFFF)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/Group_2.png',
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
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
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
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
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _navigateToImagePicker(context);
                      },
                      child: Text('Upload Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    onPressed: () {
                      if (_validateForm(context)) {
                        _createAccount(context);
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    color: Color(0xFFF9CF93),
                    iconSize: 40.0,
                    splashRadius: 35.0,
                    padding: EdgeInsets.all(0.0),
                    alignment: Alignment.center,
                    tooltip: 'Create Account',
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF9CF93),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm(BuildContext context) {
    if (_passwordController.text.length < 6) {
      _showSnackBar(context, 'Password must be at least 6 characters');
      return false;
    }

    if (_confirmPasswordController.text != _passwordController.text) {
      _showSnackBar(context, 'Passwords do not match');
      return false;
    }

    if (!_emailController.text.endsWith('@gmail.com')) {
      _showSnackBar(context, 'Invalid email format (must end with @gmail.com)');
      return false;
    }

    return true;
  }
}
