import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/splacescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp()); // Run the app
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // App theme
      ),

      home:SplaceScreen(),
    );
  }
}






