import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:openbeatsmobile/pages/homePage.dart';
import './globals/globalColors.dart' as globalColors;

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
      home: HomePage(),
      theme: ThemeData(
        brightness: globalColors.appBrightness,
        primarySwatch: globalColors.primarySwatch,
        scaffoldBackgroundColor: globalColors.backgroundClr,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: globalColors.backgroundClr,
          textTheme: TextTheme(
            title: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: globalColors.textDefaultClr,
                fontSize: 26.0,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(
            color: globalColors.iconDefaultClr,
          ),
          actionsIconTheme: IconThemeData(
            color: globalColors.iconDefaultClr,
          ),
        ),
      ),
    );
  }
}
