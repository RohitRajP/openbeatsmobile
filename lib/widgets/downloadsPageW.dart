import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar for the homePage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _downloadsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Offline Songs"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _downloadsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

// holds the loading animation
Widget loadingAnimation() {
  return Center(
      child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
  ));
}

Widget noDownloadedFiles(checkPermissionStatus) {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Text(
              "No offline media found",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              child: Text("Check Again"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                checkPermissionStatus();
              },
              color: globalVars.accentRed,
              textColor: globalVars.accentWhite,
            ),
          ],
        ),
      ));
}
