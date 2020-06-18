import 'package:obsmobile/imports.dart';

// used to handle the exceptions raised by the network request methods
void _handleExceptionsRaised(String exception, BuildContext context) {
  // holds the string to show the user
  String _userMessage;
  // constructing the right error message
  if (exception == "SocketException")
    _userMessage =
        "Unable to connect to the internet. Please check network connectivity";
  else if (exception == "TimeoutException")
    _userMessage = "Server took too long to respond. Please try again.";
  else if (exception == "BadRequestException")
    _userMessage =
        "Application sending incorrect data. Please contact developer.";
  else if (exception == "UnauthorizedException")
    _userMessage =
        "Unable to access forbidden data. Please try signing in again.";
  else
    _userMessage = "An unknown network error occurred. Please try again.";

  // constructing snackbar to show error message
  SnackBar _errorSnackBar = SnackBar(
    content: Text(
      _userMessage,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 10),
    action: SnackBarAction(
        label: "Close",
        textColor: Colors.white,
        onPressed: () {
          homePageScaffoldKey.currentState.hideCurrentSnackBar();
        }),
  );

  // checking if snackbar should be shown
  if (getCurrSnackBarErrorMsg() == null &&
      getCurrSnackBarErrorMsg() != exception) {
    // setting the current exception in global store
    setCurrSnackBarErrorMsg(exception);
    // hiding any present snackbars
    homePageScaffoldKey.currentState.removeCurrentSnackBar();
    // showing snackbar
    homePageScaffoldKey.currentState
        .showSnackBar(_errorSnackBar)
        .closed
        .then((value) => setCurrSnackBarErrorMsg(null));
  }
}

// used to classify the responses recieved for a network request
dynamic _returnResponse(Response response, BuildContext context) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return {"status": true, "data": responseJson};
    case 400:
      _handleExceptionsRaised("BadRequestException", context);
      return {"status": false, "error": "BadRequestException"};
    case 401:
    case 403:
      _handleExceptionsRaised("UnauthorizedException", context);
      return {"status": false, "error": "UnauthorizedException"};
    case 500:
    default:
      _handleExceptionsRaised("UnknownException", context);
      return {
        "status": false,
      };
  }
}

// get search suggestions for SearchNowPage
void getSearchSuggestion(BuildContext context) async {
  try {
    // getting the current search string
    String query = Provider.of<SearchTabModel>(context, listen: false).getCurrentSearchString();
    // checking if the search results have got any value
    for (int i = 0; i < 5; i++) {
      // sending http request
      var response = await get(getApiEndpoint() + "/suggester?k=" + query);
      var responseClassified = _returnResponse(response, context);
      if (responseClassified["status"] == true &&
          responseClassified["data"]["data"].length != 0) {
        // updating the seacch suggestions list
        Provider.of<SearchTabModel>(context, listen: false)
            .updateSearchSuggestions(responseClassified["data"]["data"]);
        break;
      }
    }
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", context);
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", context);
  }
}

// get ytcat search results
Future<void> getYTCatSearchResults(BuildContext context) async {
  try {
    // getting the current search string
    String query = Provider.of<SearchTabModel>(context, listen: false)
        .getCurrentSearchString();

    // checking if the search results have got any value
    for (int i = 0; i < 5; i++) {
      // sending http request
      var response = await get(getApiEndpoint() + "/ytcat?q=" + query);
      var responseClassified = _returnResponse(response, context);
      if (responseClassified["status"] == true &&
          responseClassified["data"]["data"].length != 0) {
        // updating the seacch suggestions list
        Provider.of<SearchTabModel>(context, listen: false)
            .updateSearchResults(responseClassified["data"]["data"]);
        break;
      }
    }
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", context);
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", context);
  }
}
