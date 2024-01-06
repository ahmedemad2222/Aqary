// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Image Picker and Firebase Example',
//       home: ImagePickerScreen(),
//     );
//   }
// }

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   _ImagePickerScreenState createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   List<XFile> _images = [];
//   final Reference _storageReference = FirebaseStorage.instance.ref();

//   Future<void> _pickImages() async {
//     List<XFile> resultList = [];
//     try {
//       for (int i = 0; i < 3; i++) {
//         XFile? pickedFile = await ImagePicker().pickImage(
//           source: ImageSource.gallery,
//         );

//         if (pickedFile != null) {
//           resultList.add(pickedFile);
//         }
//       }
//     } catch (e) {
//       print('Error picking images: $e');
//     }

//     if (!mounted) return;

//     setState(() {
//       _images = resultList;
//     });

//     // Upload images to Firebase Storage
//     for (XFile image in _images) {
//       await _uploadImageToFirebase(image);
//     }
//   }

//   Future<void> _uploadImageToFirebase(XFile image) async {
//     try {
//       File file = File(image.path);
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference uploadRef = _storageReference.child('images/$fileName.jpg');

//       await uploadRef.putFile(file);

//       String downloadURL = await uploadRef.getDownloadURL();
//       print('Image uploaded to Firebase Storage: $downloadURL');
//     } catch (e) {
//       print('Error uploading image to Firebase Storage: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker and Firebase Example'),
//       ),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//         ),
//         itemCount: _images.length,
//         itemBuilder: (context, index) {
//           return Image.file(
//             File(_images[index].path),
//             width: 300,
//             height: 300,
//             fit: BoxFit.cover,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImages,
//         tooltip: 'Pick Images',
//         child: const Icon(Icons.photo_library),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker and Firestore Example',
      home: ImagePickerScreen(),
    );
  }
}

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

  Future<void> _uploadImageToFirestore(XFile image, String Buildings) async {
    try {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'Buildings/$Buildings/images/$fileName.jpg';

      // Upload file to Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await _apartmentsCollection.doc(Buildings).collection('images').add({
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
