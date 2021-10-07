import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zupay/screens/root.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp;
  runApp(MaterialApp(

    theme: ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.black45,
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: Root(),));
}