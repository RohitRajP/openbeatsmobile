import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

import '../widgets/searchPageW.dart' as searchPageW;
import '../globalWids.dart' as globalWids;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // holds the list of suggestions
  List suggestionResponseList = new List();
  // scaffold key for snackBar
  final GlobalKey<ScaffoldState> _searcPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // flag variable to solve the problem of delayed api calls
  // true - add suggestions to list
  // false - do not let suggestions to list
  bool delayCallFlag = true;
  // holds data if the no internet snackbar is shown
  bool noInternetSnackbarShown = false;

  // controller to monitor if the textField becomes empty
  final TextEditingController queryFieldController =
      new TextEditingController();

  // gets suggestions as the user is typing
  void getImmediateSuggestions(String query) async {
    // construct dynamic url based on current query
    String url = "https://api.openbeats.live/suggester?k=" + query;
    // setting up exception handlers to alert for network issues
    try {
      // sending request through http as JSON
      var responseJSON = await Dio().get(url);
      // if delay flag is false, let value enter
      if (!delayCallFlag) {
        setState(() {
          // getting the list of responses
          suggestionResponseList = responseJSON.data["data"] as List;
        });
      }
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        if (!noInternetSnackbarShown) {
          globalFun.showSnackBars(10, _searcPageScaffoldKey, context);
          setState(() {
            noInternetSnackbarShown = true;
          });
        }
      }
      return;
    }
    // removing the noInternet snackbar when internet connection is returned
    _searcPageScaffoldKey.currentState.removeCurrentSnackBar();
  }

  // calling function to monitor the textField to handle delayed responses
  // and empty textField edge cases
  void addListenerToSearchTextField() {
    // adding listener to textField
    queryFieldController.addListener(() {
      if (queryFieldController.text.length == 0) {
        setState(() {
          // setting delay flag to block till the field has value again
          delayCallFlag = true;
          // clearing the suggestion response list
          suggestionResponseList.clear();
        });
      } else {
        setState(() {
          // setting delay flag to let value enter
          delayCallFlag = false;
        });
      }
    });
  }

  // sends suggestions to the textField
  void sendSuggestionToField(String suggestion) {
    // modifying query field value
    queryFieldController.text = suggestion;
    // sending cursor to end of queryField
    queryFieldController.selection =
        TextSelection.collapsed(offset: queryFieldController.text.length);
    // calling function to update suggestions
    getImmediateSuggestions(suggestion);
  }

  @override
  void initState() {
    super.initState();
    // calling function to monitor the textField to handle delayed responses
    // and empty textField edge cases
    addListenerToSearchTextField();
    // to check if the global value exsists to be inserted
    if (globalVars.currSearchText.length > 1) {
      // inserting persistent text into the field
      queryFieldController.text = globalVars.currSearchText;
      // setting cursor to end of the inserted text
      queryFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: queryFieldController.text.length));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    queryFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _searcPageScaffoldKey,
        backgroundColor: globalVars.primaryDark,
        appBar: searchPageW.appBarSearchPageW(
            queryFieldController, getImmediateSuggestions, context),
        body: (suggestionResponseList.length != 0)
            ? searchResultListView(false)
            : (globalVars.searchHistory.length != 0)
                ? searchResultListView(true)
                : Container(),
      ),
    );
  }

  // holds the list view builder responsible for showing the suggestions
  Widget searchResultListView(bool showHistory) {
    return ListView.builder(
      itemBuilder: (context, index) =>
          suggestionsListBuilder(context, index, showHistory),
      itemCount: (showHistory)
          ? (globalVars.searchHistory.length < 10)
              ? globalVars.searchHistory.length
              : 10
          : suggestionResponseList.length,
    );
  }

  // builds the suggestions listView
  Widget suggestionsListBuilder(
      BuildContext context, int index, bool showHistory) {
    return ListTile(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Text(
          (showHistory)
              ? globalVars.searchHistory[index]
              : suggestionResponseList[index][0],
          style: TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: Icon(Icons.search, color: Colors.grey,),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            updateQueryBtn(showHistory, index),
            SizedBox(
              width: 2.0,
            ),
            deleteSearchResultBtn(showHistory, index),
          ],
        ),
      ),
      onTap: () {
        // setting global variable to persist search
        globalVars.currSearchText = (showHistory)
            ? globalVars.searchHistory[index]
            : suggestionResponseList[index][0];
        // going back to previous screen with the suggestion data
        Navigator.pop(
            context,
            (showHistory)
                ? globalVars.searchHistory[index]
                : suggestionResponseList[index][0]);
      },
    );
  }

  Widget updateQueryBtn(bool showHistory, int index) {
    return Transform.rotate(
        angle: -50 * math.pi / 180,
        child: IconButton(
          tooltip: "Update query",
          icon: Icon(Icons.arrow_upward),
          iconSize: 20.0,
          onPressed: () {
            // setting global variable to persist search
            globalVars.currSearchText = (showHistory)
                ? globalVars.searchHistory[index]
                : suggestionResponseList[index][0];
            // sending the current text to the search field
            sendSuggestionToField((showHistory)
                ? globalVars.searchHistory[index]
                : suggestionResponseList[index][0]);
          },
          color: Colors.grey,
        ));
  }

  Widget deleteSearchResultBtn(bool showHistory, int index) {
    return Container(
      child: (showHistory)
          ? IconButton(
              tooltip: "Delete Search Result",
              icon: Icon(Icons.clear),
              iconSize: 20.0,
              onPressed: () {
                setState(() {
                  // removing search histoy listing
                  globalVars.searchHistory.removeAt(index);
                });
                globalFun.updateSearchHistorySharedPrefs();
              },
              color: Colors.grey,
            )
          : null,
    );
  }
}
