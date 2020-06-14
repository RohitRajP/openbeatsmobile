import 'package:openbeatsmobile/imports.dart';
import './widgets/searchNowPageW.dart' as searchNowPageW;

class SearchNowPage extends StatefulWidget {
  @override
  _SearchNowPageState createState() => _SearchNowPageState();
}

class _SearchNowPageState extends State<SearchNowPage> {
// holds the list of suggestions
  List suggestionResponseList = new List();
  // controller to monitor if the textField becomes empty
  final TextEditingController queryFieldController =
      new TextEditingController();
  // flag variable to solve the problem of delayed api calls
  // true - add suggestions to list
  // false - do not let suggestions to list
  bool _delayCallFlag = true;
  // holds data if the no internet snackbar is shown
  bool _noInternetSnackbarShown = false;

  // gets suggestions as the user is typing
  void getSearchSuggestions(String query) async {
    // construct dynamic url based on current query
    String url = AppComponents().apiHostAddress + "/suggester?k=" + query;
    // setting up exception handlers to alert for network issues
    try {
      // sending request through http as JSON
      var response = await get(url);
      var responseJSON = jsonDecode(response.body);

      // if delay flag is false, let value enter
      if (!_delayCallFlag) {
        setState(() {
          // getting the list of responses
          suggestionResponseList = responseJSON["data"] as List;
          _noInternetSnackbarShown = false;
        });
      }
      if (this.mounted)
        // removing the noInternet snackbar when internet connection is returned
        searchNowPageScaffoldKey.currentState.removeCurrentSnackBar();
    } catch (e) {
      // catching dio error
      if (!_noInternetSnackbarShown) {
        AppComponents().showSnackBars(
          searchNowPageScaffoldKey,
          context,
          "Not able to connect to server",
          Colors.orange,
          Duration(minutes: 30),
        );
        setState(() {
          _noInternetSnackbarShown = true;
        });
      }
    }
  }

  // calling function to monitor the textField to handle delayed responses
  // and empty textField edge cases
  void addListenerToSearchTextField() {
    // adding listener to textField
    queryFieldController.addListener(() {
      if (queryFieldController.text.length == 0) {
        setState(() {
          // setting delay flag to block till the field has value again
          _delayCallFlag = true;
          // clearing the suggestion response list
          suggestionResponseList.clear();
        });
      } else {
        setState(() {
          // setting delay flag to let value enter
          _delayCallFlag = false;
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
    getSearchSuggestions(suggestion);
  }

  @override
  void initState() {
    super.initState();
    // calling function to monitor the textField to handle delayed responses
    // and empty textField edge cases
    addListenerToSearchTextField();
    // to check if the global value Exists to be inserted
    if (getCurrSearchString().length > 1) {
      // inserting persistent text into the field
      queryFieldController.text = getCurrSearchString();
      // setting cursor to end of the inserted text
      queryFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: queryFieldController.text.length));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    queryFieldController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    DebugFunctions().printMessage("=======SearchNowPage=======");
    return Scaffold(
      key: searchNowPageScaffoldKey,
      appBar: searchNowPageW.appBar(
          queryFieldController, getSearchSuggestions, context),
      body: searchNowViewBody(),
    );
  }

  // holds the SearchNowView Body
  Widget searchNowViewBody() {
    return Container(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: (suggestionResponseList.length != 0)
            ? suggestionsListBuilder(false)
            : AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: (getSearchHistory().length != 0)
                    ? suggestionsListBuilder(true)
                    : Container(),
              ),
      ),
    );
  }

  // holds the list view builder responsible for showing the suggestions and search history
  Widget suggestionsListBuilder(showHistory) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        searchNowPageW.suggestionsTitleW(showHistory),
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => searchNowPageW.suggestionsListTile(
              context,
              index,
              showHistory,
              suggestionResponseList,
              sendSuggestionToField),
          itemCount: (showHistory)
              ? (getSearchHistory().length < 10)
                  ? getSearchHistory().length
                  : 10
              : suggestionResponseList.length,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        )
      ],
    );
  }
}
