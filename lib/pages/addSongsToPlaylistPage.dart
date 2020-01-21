import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:openbeatsmobile/pages/addSongsToPlaylistPage.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../widgets/addSongsToPlaylistW.dart' as addSongsToPlaylistW;

class AddSongsToPlaylistPage extends StatefulWidget {
  var videosResponseItem;
  AddSongsToPlaylistPage(this.videosResponseItem);
  @override
  _AddSongsToPlaylistPageState createState() => _AddSongsToPlaylistPageState();
}

class _AddSongsToPlaylistPageState extends State<AddSongsToPlaylistPage> {
  bool _isLoading = true,
      _addingSongFlag = false,
      createPlaylistValidate = false;
  final GlobalKey<ScaffoldState> _addSongsToPlaylistPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _newPlaylistFormKey = GlobalKey<FormState>();
  // holds the response data from the playlist server
  var dataResponse;
  // holds the name of playList to be created
  String newPlaylistName;

  // shows the createPlaylist Box
  void showCreatePlayListBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: globalVars.primaryDark,
            title: Text("Create Playlist"),
            content: Form(
              key: _newPlaylistFormKey,
              child: TextFormField(
                autofocus: true,
                onSaved: (String val) {
                  newPlaylistName = val;
                },
                decoration: InputDecoration(
                  hintText: "Playlist Name",
                ),
                autovalidate: createPlaylistValidate,
                validator: (String args) {
                  if (args.length == 0)
                    return "Please enter a name for your playlist";
                  else
                    return null;
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  setState(() {
                    createPlaylistValidate = false;
                  });
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                textColor: globalVars.accentRed,
              ),
              FlatButton(
                child: Text("Proceed"),
                onPressed: () {
                  validateCreatePlayListField();
                },
                color: Colors.transparent,
                textColor: globalVars.accentGreen,
              ),
            ],
          );
        });
  }

  // validates the createPlaylistField
  void validateCreatePlayListField() {
    if (_newPlaylistFormKey.currentState.validate()) {
      _newPlaylistFormKey.currentState.save();
      sendCreatePlaylistReq();
    } else {
      setState(() {
        createPlaylistValidate = true;
      });
    }
  }

  // sends createPlaylist request
  void sendCreatePlaylistReq() async {
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
        Navigator.pop(context);
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

  // adds the song to the playlist
  void addSongToPlayList(playListId, playListName, videoResponseItem) async {
    List<dynamic> songsList = new List();
    songsList.add(videoResponseItem);
    setState(() {
      _addingSongFlag = true;
      globalFun.showSnackBars(1, _addSongsToPlaylistPageScaffoldKey, context);
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/addsongs",
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode({
            "playlistId": playListId,
            "songs": songsList,
          }));
      var responseJSON = json.decode(response.body);

      if (responseJSON["status"] == true) {
        Navigator.pop(context);
        globalFun.showToastMessage(
            "Added to " + playListName, Colors.green, Colors.white);
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
    getListofPlayLists();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _addSongsToPlaylistPageScaffoldKey,
        backgroundColor: globalVars.primaryDark,
        appBar: addSongsToPlaylistW.appBar(),
        body: addSongsToPlaylistPageBody(),
      ),
    );
  }

  Widget addSongsToPlaylistPageBody() {
    return Container(
      color: globalVars.primaryDark,
      padding: EdgeInsets.all(20.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          createPlaylistsBtn(),
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: Container(
                child:
                    (dataResponse != null && dataResponse["data"].length != 0)
                        ? Text(
                            "Your Playlists",
                            style: TextStyle(color: Colors.grey),
                          )
                        : null),
          ),
          SizedBox(
            height: 10.0,
          ),
          playListsView()
        ],
      ),
    );
  }

  Widget playListsView() {
    return Center(
      child: Container(
        child: (_isLoading)
            ? SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(globalVars.accentRed),
                ),
              )
            : (dataResponse != null && dataResponse["data"].length != 0)
                ? playListsListView()
                : Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "You seem to have no playlists,\nwhy not try creating one?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                  ),
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
        enabled: !_addingSongFlag,
        leading: Icon(
          FontAwesomeIcons.thList,
          color: globalVars.accentWhite,
        ),
        title: Text(
          dataResponse["data"][index]["name"],
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          addSongToPlayList(dataResponse["data"][index]["playlistId"],
              dataResponse["data"][index]["name"], widget.videosResponseItem);
        },
      ),
    );
  }

  Widget createPlaylistsBtn() {
    return RaisedButton(
      onPressed: () {
        if (!_addingSongFlag) {
          showCreatePlayListBox();
        }
      },
      shape: StadiumBorder(),
      textColor: globalVars.accentRed,
      color: globalVars.accentWhite,
      child: Text(
        "Create Playlist",
        style: TextStyle(fontSize: 18.0),
      ),
      padding: EdgeInsets.all(20.0),
    );
  }
}
