import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      color: Colors.red,
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "montserrat",
        primarySwatch: Colors.red,
      ),
    );
  }
}
