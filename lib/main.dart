import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi/page/login_screen.dart';
import 'package:flutter_taxi/page/main_screen.dart';
import 'package:flutter_taxi/page/registration_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'DataHandler/app_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TaxiApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class TaxiApp extends StatelessWidget {
  static const String idScreen = 'main';
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child('users');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MapsScreen(),
        initialRoute: MapsScreen.idScreen,
        routes: {
          LoginScreen.idScreen: (contex) => LoginScreen(),
          MapsScreen.idScreen: (contex) => MapsScreen(),
          RegistrationScreen.idScreen: (contex) => RegistrationScreen(),
        },
      ),
    );
  }
}
