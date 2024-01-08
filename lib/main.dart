import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ThemeProvider.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/splashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: context.watch<ThemeProvider>().themeData,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<ThemeProvider>().themeData,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}