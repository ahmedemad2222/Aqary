import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  List<XFile> _images = [];
  final CollectionReference _apartmentsCollection =
      FirebaseFirestore.instance.collection('Buildings');

  Future<void> _pickImages() async {
    List<XFile> resultList = [];
    try {
      for (int i = 0; i < 3; i++) {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        if (pickedFile != null) {
          resultList.add(pickedFile);
        }
      }

    } catch (e) {
      print('Error picking images: $e');
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
    });

    // Upload images to a specific apartment in Firestore
    // for (XFile image in _images) {
    //   await _uploadImageToFirestore(image, 'Buildings');
    // }
    Navigator.pop(context, _images);
  }

  Future<void> _uploadImageToFirestore(XFile image, String images,String Category) async {
    try {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'Buildings/$images/images/$fileName.jpg';
      // Upload file to Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await _apartmentsCollection.doc(images).collection('images').add({
          'path': filePath,
        });
      });

      print('Image uploaded to Firestore: $filePath');
    } catch (e) {
      print('Error uploading image to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker and Firestore Example'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(_images[index].path),
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        tooltip: 'Pick Images',
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}
