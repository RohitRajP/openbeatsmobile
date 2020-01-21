import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './globalVars.dart' as globalVars;
import './actions/globalVarsA.dart' as globalVarsA;

// holds the drawer for the application
// currPage
// 1 - homePage
// 2 - topChartsPage
// 3 - artistsPage
// 4 - albumsPage
// 5 - historyPage
// 6 - yourPlaylistsPage
// 7 - likedSongsPage
// 8 - yourDownloadsPage
Widget drawerW(int currPage, context) {
  return Drawer(
    child: Container(
      color: globalVars.primaryDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(context),
          drawerHomePageListTile(currPage, context),
          drawerTopChartsPageListTile(currPage, context),
          drawerArtistsPageListTile(currPage, context),
          drawerAlbumsPageListTile(currPage, context),
          drawerHistoryPageListTile(currPage, context),
          drawerYourPlaylistsPageListTile(currPage, context),
          drawerLikedSongsPageListTile(currPage, context),
          drawerYourDownloadsPageListTile(currPage, context),
          drawerappsettingsPageListTile(currPage, context),
          drawerLogoutPageListTile(context),
        ],
      ),
    ),
  );
}

// holds the drawerHeader
Widget drawerHeader(context) {
  String userAvatar = globalVars.loginInfo["userAvatar"];
  if (userAvatar != "user_avatar")
    userAvatar = "http://" + userAvatar.substring(2, userAvatar.length);
  else
    userAvatar = "https://picsum.photos/200";
  return (globalVars.loginInfo["loginStatus"])
      ? UserAccountsDrawerHeader(
          accountName: Text(
            globalVars.loginInfo["userName"],
            style: TextStyle(color: globalVars.primaryLight),
          ),
          accountEmail: Text(
            globalVars.loginInfo["userEmail"],
            style: TextStyle(color: globalVars.primaryLight),
          ),
          decoration: BoxDecoration(color: globalVars.primaryDark),
          currentAccountPicture: CircleAvatar(
            backgroundColor: globalVars.accentWhite,
            child: CachedNetworkImage(
              imageUrl: userAvatar,
              placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(globalVars.accentRed)),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        )
      : SizedBox(
          height: 100.0,
          child: Container(
            child: RaisedButton(
              child: Text(
                "Login/SignUp\nto access exciting features",
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/authPage');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
        );
}

// holds the homePage listTile for the drawer
Widget drawerHomePageListTile(int currPage, context) {
  return Container(
    child: (currPage != 1)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.home, color: globalVars.leadingIconColor),
            title: Text('Home',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Go back to the home page",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/homePage');
            },
          )
        : null,
  );
}

// holds the topChartsPage listTile for the drawer
Widget drawerTopChartsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 2)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.chartLine,
                color: globalVars.leadingIconColor),
            title: Text('Top Charts',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Listen to what's trending",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/topChartsPage');
            },
          )
        : null,
  );
}

// holds the artistsPage listTile for the drawer
Widget drawerArtistsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 3)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.users,
                color: globalVars.leadingIconColor),
            title: Text('Artists',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Songs from your favorite artists",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/artistsPage');
            },
          )
        : null,
  );
}

// holds the albumsPage listTile for the drawer
Widget drawerAlbumsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 4)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.solidClone,
                color: globalVars.leadingIconColor),
            title: Text('Albums',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Browse the albums you love",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/albumsPage');
            },
          )
        : null,
  );
}

// holds the historyPage listTile for the drawer
Widget drawerHistoryPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 5)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.history,
                color: globalVars.leadingIconColor),
            title: Text('Recently Played',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Your own music history",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              if (globalVars.loginInfo["loginStatus"] == true) {
                // navigating to homePage
                Navigator.pushReplacementNamed(context, '/historyPage');
              } else {
                showToastMessage("Please login to use feature", Colors.black, Colors.white);
                Navigator.pushNamed(context, '/authPage');
              }
            },
          )
        : null,
  );
}

// holds the yourPlaylistsPage listTile for the drawer
Widget drawerYourPlaylistsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 6)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.list, color: globalVars.leadingIconColor),
            title: Text('Your Playlists',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Tune to your own collections",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              if (globalVars.loginInfo["loginStatus"] == true) {
                // navigating to homePage
                Navigator.pushReplacementNamed(context, '/yourPlaylistsPage');
              } else {
                showToastMessage("Please login to use feature", Colors.black, Colors.white);
                Navigator.pushNamed(context, '/authPage');
              }
            },
          )
        : null,
  );
}

// holds the likedSongsPage listTile for the drawer
Widget drawerLikedSongsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 7)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.heart,
                color: globalVars.leadingIconColor),
            title: Text('Liked Songs',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("All your liked songs",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              if (globalVars.loginInfo["loginStatus"] == true) {
                // navigating to homePage
                Navigator.pushReplacementNamed(context, '/likedSongsPage');
              } else {
                showToastMessage("Please login to use feature",Colors.black, Colors.white);
                Navigator.pushNamed(context, '/authPage');
              }
            },
          )
        : null,
  );
}

// holds the yourDownloadsPage listTile for the drawer
Widget drawerYourDownloadsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 8)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.download,
                color: globalVars.leadingIconColor),
            title: Text('Your Donwloads',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("All songs on local device",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              if (globalVars.loginInfo["loginStatus"] == true) {
                // navigating to homePage
                Navigator.pushReplacementNamed(context, '/yourDownloadsPage');
              } else {
                showToastMessage("Please login to use feature", Colors.black, Colors.white);
                Navigator.pushNamed(context, '/authPage');
              }
            },
          )
        : null,
  );
}

// holds the appsettings listTile for the drawer
Widget drawerappsettingsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 9)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.cogs, color: globalVars.leadingIconColor),
            title: Text('Settings',
                style: TextStyle(color: globalVars.titleTextColor)),
            subtitle: Text("Application related settings",
                style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/appSettings');
            },
          )
        : null,
  );
}

// holds the logout listTile for the drawer
Widget drawerLogoutPageListTile(context) {
  return Container(
    child: (globalVars.loginInfo["loginStatus"])
        ? ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.orange),
            title: Text('Logout', style: TextStyle(color: Colors.orange)),
            subtitle: Text("Sign out of your account",
                style: TextStyle(color: Colors.orange)),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: globalVars.primaryDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      title: Text("Are you sure?"),
                      content:
                          Text("This action will sign you out of your account"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Logout"),
                          onPressed: () {
                            Map<String, dynamic> loginParameters = {
                              "loginStatus": false,
                            };
                            globalVarsA.modifyLoginInfo(loginParameters, true);
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, '/homePage');
                            showToastMessage("Logged out Successfully", Colors.black, Colors.white);
                          },
                          color: Colors.transparent,
                          textColor: globalVars.accentRed,
                        ),
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.transparent,
                          textColor: globalVars.accentGreen,
                        )
                      ],
                    );
                  });
            },
          )
        : null,
  );
}

// function to show ToastMessage
void showToastMessage(String message, Color bgColor, Color txtColor) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: 16.0);
}

// function to show snackBars
void showSnackBars(int mode, GlobalKey<ScaffoldState> scaffoldKey, monitorPlaybackStart, context){
  // holds the message to display
    String snackBarMessage;
    // flag to indicate if snackbar action has to be shown
    // 1 - permission action / 2 - download cancel
    int showAction = 0;
    // flag to indicate if CircularProgressIndicatior must be shown
    bool showLoadingAnim = true;
    // holds color of snackBar
    Color snackBarColor;
    // duration of snackBar
    Duration snackBarDuration = Duration(minutes: 1);
    switch (mode) {
      case 0:
        snackBarMessage = "Initializing playback...";
        snackBarColor = Colors.green;
        snackBarDuration = Duration(seconds: 30);
        // calling function to monitor the playback start point to remove snackbar
        monitorPlaybackStart();
        break;
      case 1:
        snackBarMessage = "Adding song to playlist...";
        snackBarColor = Colors.orange;
        snackBarDuration = Duration(seconds: 30);
        break;
    }
    // constructing snackBar
    SnackBar statusSnackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: (showLoadingAnim)
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    )
                  : SizedBox(
                      child: null,
                    )),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            child: Text(
              snackBarMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      backgroundColor: snackBarColor,
      duration: snackBarDuration,
    );
    // removing any previous snackBar
    scaffoldKey.currentState.removeCurrentSnackBar();
    // showing new snackBar
    scaffoldKey.currentState.showSnackBar(statusSnackBar);
}