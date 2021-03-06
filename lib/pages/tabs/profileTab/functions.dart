// holds the validator for sign in
import 'package:obsmobile/imports.dart';

// used to validate the textfields
Future<Map<String, dynamic>> validateFields(
    BuildContext context, Map<String, dynamic> parameters) async {
  if (parameters["_formKey"].currentState.validate()) {
    if (parameters["_isJoin"]) {
      // getting values
      String _emailAddress =
          parameters["_emailFieldController"].text.toString().trim();
      String _password = parameters["_passwordFieldController"].text;
      String _userName = parameters["_userNameFieldController"].text;
      // sending data to get login authentication
      var responseJSON = await joinHandler(
          {"email": _emailAddress, "password": _password, "name": _userName},
          context);
      if (responseJSON["status"] == true) {
        Map<String, String> _responseData = {
          "token": responseJSON["data"]["token"],
          "name": responseJSON["data"]["name"],
          "email": responseJSON["data"]["email"],
          "id": responseJSON["data"]["id"],
          "avatar": responseJSON["data"]["avatar"]
        };
        // sending data to store in sharedPreferences
        storeUserDetails(_responseData);
        // storing data in data model
        Provider.of<UserModel>(context, listen: false)
            .setUserDetails(_responseData);
        // storing user token in audioService
        AudioServiceOps().setUserToken(_responseData["token"]);
        return {"status": true};
      } else {
        return {"status": false, "message": responseJSON["data"]};
      }
    } else {
      // getting values
      String _emailAddress =
          parameters["_emailFieldController"].text.toString().trim();
      String _password = parameters["_passwordFieldController"].text;
      // sending data to get login authentication
      var responseJSON = await loginAuthticationHandler(
          {"email": _emailAddress, "password": _password}, context);

      if (responseJSON["status"] == true) {
        Map<String, String> _responseData = {
          "token": responseJSON["data"]["token"],
          "name": responseJSON["data"]["name"],
          "email": responseJSON["data"]["email"],
          "id": responseJSON["data"]["id"],
          "avatar": responseJSON["data"]["avatar"]
        };
        // sending data to store in sharedPreferences
        storeUserDetails(_responseData);
        // storing data in data model
        Provider.of<UserModel>(context, listen: false)
            .setUserDetails(_responseData);
        // storing user token in audioService
        AudioServiceOps().setUserToken(_responseData["token"]);
        return {"status": true};
      } else
        return {"status": false, "message": "Invalid Credentials"};
    }
  } else {
    if (parameters["_isJoin"]) {
      Provider.of<ProfileTabData>(context, listen: false)
          .setAuthContainerHeight(MediaQuery.of(context).size.height * 0.55);
      Provider.of<ProfileTabData>(context, listen: false)
          .setAutoValidateJoin(true);
      return {"status": false, "message": "Invalid Data Provided"};
    } else {
      Provider.of<ProfileTabData>(context, listen: false)
          .setAutoValidateSignIn(true);
      return {"status": false, "message": "Invalid Data Provided"};
    }
  }
}

// used to logout the user
void logoutUser(BuildContext context) async {
  showFlushBar(
    context,
    {
      "message": "So sad to see you go! 🥺",
      "color": Colors.deepOrange,
      "duration": Duration(seconds: 5),
      "title": "Bye Bye",
      "blocking": false,
      "icon": Icon(
        FontAwesomeIcons.sadTear,
        size: 18.0,
      ),
    },
  );
  // remove user data from the sharedPreferences
  removeUserDetails();
  // removes user data from the provider models
  Provider.of<UserModel>(context, listen: false).setUserDetails({});
  Provider.of<LibraryTabData>(context, listen: false).setUserCollections({});
  Provider.of<LibraryTabData>(context, listen: false).setUserPlaylists({});
  // removes user token from the audio service
  AudioServiceOps().setUserToken("");
}
