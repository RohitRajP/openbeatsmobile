import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;
import '../widgets/yourPlaylistsPageW.dart' as yourPlaylistsPageW;

class YourPlaylistsPage extends StatefulWidget {
  @override
  _YourPlaylistsPageState createState() => _YourPlaylistsPageState();
}

class _YourPlaylistsPageState extends State<YourPlaylistsPage> {
  final GlobalKey<ScaffoldState> _yourPlaylistsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _newPlaylistFormKey = GlobalKey<FormState>();

  // holds value regarding if the page is loading content
  bool _isLoading = true, createPlaylistValidate = false;
  // holds the list of playlists
  var dataResponse;
  // holds the new playlist name
  String newPlaylistName;

  // shows the createPlaylist Box
  // mode 1 - create playlist
  // mode 2 - rename playlist
  void showCreateOrRenamePlayListBox(mode, int index) {
    setState(() {
      createPlaylistValidate = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: globalVars.primaryDark,
            title:
                (mode == 1) ? Text("Create Playlist") : Text("Rename Playlist"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Form(
              key: _newPlaylistFormKey,
              child: TextFormField(
                autofocus: true,
                initialValue:
                    (mode == 1) ? null : dataResponse["data"][index]["name"],
                onSaved: (String val) {
                  newPlaylistName = val;
                },
                decoration: InputDecoration(
                  hintText: (mode == 1) ? "Playlist Name" : "New Playlist Name",
                ),
                autovalidate: createPlaylistValidate,
                validator: (String args) {
                  if (args.length == 0)
                    return (mode == 1)
                        ? "Please enter a name for your playlist"
                        : "Please enter a new name for your playlist";
                  else
                    return null;
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                textColor: globalVars.accentRed,
              ),
              FlatButton(
                child: (mode == 1) ? Text("Create") : Text("Rename"),
                onPressed: () {
                  validateCreatePlayListField(mode, index);
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                textColor: globalVars.accentGreen,
              ),
            ],
          );
        });
  }

  // shows the delete playlists confirmation dialog
  void showDeletePlaylistConfirmationBox(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: globalVars.primaryDark,
              title: Text("Are you sure?"),
              content: Text(
                  "This action will delete the playlist from your account"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentGreen,
                ),
                FlatButton(
                  child: Text("Delete Playlist"),
                  onPressed: () {
                    deletePlayListReq(index);
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentRed,
                ),
              ],
            ));
  }

  void deletePlayListReq(index) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.get(
        "https://api.openbeats.live/playlist/userplaylist/delete/" +
            dataResponse["data"][index]["playlistId"],
      );
      var responseJSON = json.decode(response.body);
      if (responseJSON["status"] == true) {
        getListofPlayLists();
        globalFun.showToastMessage(
            "Successfully deleted playlist", Colors.green, Colors.white);
      } else {
        globalFun.showToastMessage(
            "Apologies, response error", Colors.red, Colors.white);
      }
    } catch (err) {
      print(err);
      globalFun.showToastMessage(
          "Apologies, some error occurred", Colors.red, Colors.white);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // validates the createPlaylistField
  void validateCreatePlayListField(int mode, int index) {
    if (_newPlaylistFormKey.currentState.validate()) {
      _newPlaylistFormKey.currentState.save();
      (mode == 1) ? sendCreatePlaylistReq() : sendRenamePlaylistReq(index);
    } else {
      setState(() {
        createPlaylistValidate = true;
      });
    }
  }

  // send renamePlaylist request
  void sendRenamePlaylistReq(index) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/updatename",
          body: {
            "playlistId": dataResponse["data"][index]["playlistId"],
            "name": "$newPlaylistName"
          });
      var responseJSON = json.decode(response.body);
      if (responseJSON["status"] == true) {
        getListofPlayLists();
        globalFun.showToastMessage(
            "Playlist Renamed", Colors.green, Colors.white);
      } else {
        globalFun.showToastMessage(
            "Apologies, response error", Colors.red, Colors.white);
      }
    } catch (err) {
      print(err);
      globalFun.showToastMessage(
          "Apologies, some error occurred", Colors.red, Colors.white);
    }
  }

  // sends createPlaylist request
  void sendCreatePlaylistReq() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/create",
          body: {
            "name": "$newPlaylistName",
            "userId": "${globalVars.loginInfo["userId"]}"
          });
      var responseJSON = json.decode(response.body);
      if (responseJSON["status"] == true) {
        getListofPlayLists();
        globalFun.showToastMessage(
            "Created playlist " + newPlaylistName, Colors.green, Colors.white);
      } else {
        globalFun.showToastMessage(
            "Apologies, response error", Colors.red, Colors.white);
      }
    } catch (err) {
      print(err);
      globalFun.showToastMessage(
          "Apologies, some error occurred", Colors.red, Colors.white);
    }
  }

  // gets the playlists of the user
  void getListofPlayLists() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/userplaylist/getallplaylistmetadata/" +
              globalVars.loginInfo["userId"]);
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      globalFun.showToastMessage(
          "Apologies, some error occurred", Colors.red, Colors.white);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getting list of playlists
    getListofPlayLists();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _yourPlaylistsPageScaffoldKey,
        backgroundColor: globalVars.primaryDark,
        appBar:
            yourPlaylistsPageW.appBarW(context, _yourPlaylistsPageScaffoldKey),
        drawer: globalFun.drawerW(6, context),
        body: yourPlayListPageBody(),
      ),
    );
  }

  Widget yourPlayListPageBody() {
    return Container(
      child: (_isLoading)
          ? yourPlaylistsPageW.playlistsLoading()
          : ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                yourPlaylistsPageW
                    .createPlaylistsBtn(showCreateOrRenamePlayListBox),
                SizedBox(
                  height: 40.0,
                ),
                (dataResponse["data"].length != 0)
                    ? playListsListView()
                    : yourPlaylistsPageW.noPlaylistsMessage()
              ],
            ),
    );
  }

  Widget playListsListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataResponse["data"].length,
      itemBuilder: playListsListViewBody,
    );
  }

  Widget playListsListViewBody(context, index) {
    return Container(
      child: ListTile(
          leading: Icon(
            FontAwesomeIcons.thList,
            color: globalVars.accentWhite,
          ),
          title: Text(
            dataResponse["data"][index]["name"],
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {},
          trailing: Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.1,
            child: PopupMenuButton<String>(
                elevation: 30.0,
                icon: Icon(
                  Icons.more_vert,
                  size: 30.0,
                ),
                onSelected: (choice) {
                  if (choice == "rename") {
                    showCreateOrRenamePlayListBox(2, index);
                  } else if (choice == "delete") {
                    showDeletePlaylistConfirmationBox(index);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: "rename",
                          child: ListTile(
                            title: Text("Rename Playlist"),
                          )),
                      PopupMenuItem(
                          value: "delete",
                          child: ListTile(
                            title: Text(
                              "Delete Playlist",
                              style: TextStyle(color: Colors.orange),
                            ),
                          )),
                    ]),
          )),
    );
  }
}
