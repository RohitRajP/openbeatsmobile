import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/globalVars.dart' as globalVars;

// holds the AppBar for the profileHomeView
Widget appBar() {
  return AppBar(
    title: Text("Profile"),
  );
}

// holds the email textfield for the tabView
Widget emailTxtField(
    BuildContext context, bool issignIn, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      cursorColor: globalColors.iconActiveClr,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: InputBorder.none,
        alignLabelWithHint: false,
        icon: Icon(Icons.email),
        hintText: "Email Address",
      ),
    ),
  );
}

// holds the password textfield for the tabView
Widget passwordTxtField(
    BuildContext context,
    bool issignIn,
    TextEditingController controller,
    bool hidePasswordField,
    Function togglePasswordVisibility) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      cursorColor: globalColors.iconActiveClr,
      obscureText: hidePasswordField,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              (hidePasswordField) ? Icons.visibility_off : Icons.visibility),
          iconSize: 20.0,
          color: globalColors.iconDisabledClr,
          onPressed: togglePasswordVisibility,
        ),
        hintText: "Password",
      ),
    ),
  );
}

// holds the action button for the tabview
Widget actionBtnW(
    BuildContext context, bool issignIn, Function callbackFun, bool isLoading) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    height: 48,
    child: RaisedButton(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: (isLoading)
          ? _actionBtnLoadingAnim()
          : (issignIn) ? Text("Sign In") : Text("Join"),
      color: globalColors.mainBtnClr,
      onPressed: (isLoading) ? () {} : callbackFun,
    ),
  );
}

// holds the loading animation for the action button
Widget _actionBtnLoadingAnim() {
  return SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(globalColors.darkBgIconClr),
    ),
  );
}

// holds the forgot password button
Widget fgtPasswordBtn(BuildContext context) {
  return GestureDetector(
    child: Text(
      "Forgot Password?",
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(),
    ),
    onTap: () {},
  );
}

// holds the username textfield for the tabview
Widget userNameTextField(
    BuildContext context, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      cursorColor: globalColors.iconActiveClr,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.person),
        hintText: "User Name",
      ),
    ),
  );
}

// holds the greeting message for the signIn tab
Widget signInTabGreetingMessage() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      "hello!",
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 60.0,
          color: globalColors.textActiveClr),
    ),
  );
}

// hodls the greeting message subtitle for the signIn tab
Widget signInTabGreetingSubtitleMessage() {
  return Container(
    child: Text(
      "Sign In to your account",
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: globalColors.textDefaultClr,
      ),
    ),
  );
}

// holds the greeitng messsage for the join tab
Widget joinTabGreetingMessage() {
  return Container(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "join!\n",
        style: GoogleFonts.openSans(
            color: globalColors.textActiveClr,
            height: 1.6,
            fontWeight: FontWeight.bold,
            fontSize: 60.0),
        children: [
          TextSpan(
            text: "with your own",
            style: GoogleFonts.openSans(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
          TextSpan(
            text: " Open",
            style: GoogleFonts.roboto(
                color: globalColors.textActiveClr,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          TextSpan(
            text: "Beats",
            style: GoogleFonts.roboto(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          TextSpan(
            text: " account",
            style: GoogleFonts.openSans(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
        ],
      ),
    ),
  );
}

// holds the profileview
Widget profileView(BuildContext context, Function signoutCallback) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.55,
    width: MediaQuery.of(context).size.width,
    child: Card(
      elevation: 5.0,
      color: globalColors.profileBgClr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          avatarImageView(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          nameofUser(),
          emailOfUser(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          logoutTxtBtn(signoutCallback),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
    ),
  );
}

// holds the avatar image for the profileView
Widget avatarImageView() {
  return SizedBox(
    height: 100.0,
    width: 100.0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.5,
            offset: new Offset(1.0, 1.0),
          ),
        ]),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: globalVars.userDetails["avatar"],
          placeholder: (context, url) => Center(
            child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    ),
  );
}

// holds the nameW of the user for the profileView
Widget nameofUser() {
  return Text(
    globalVars.userDetails["name"],
    textAlign: TextAlign.center,
    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 24.0),
  );
}

// holds the emailW of the user for the profileView
Widget emailOfUser() {
  return Text(
    globalVars.userDetails["email"],
    textAlign: TextAlign.center,
    style: GoogleFonts.openSans(fontSize: 16.0),
  );
}

// holds the logout button for the profileView
Widget logoutTxtBtn(Function logoutCallback) {
  return GestureDetector(
    child: Text(
      "Sign Out",
      style: GoogleFonts.openSans(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: globalColors.textActiveClr),
      textAlign: TextAlign.center,
    ),
    onTap: logoutCallback,
  );
}

// app settings title
Widget settingsWTitle() {
  return Container(
    margin: EdgeInsets.only(left: 17.0),
    child: Text(
      "Settings",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
    ),
  );
}

// holds the dark mode settings toggle
Widget darkModeSettingsToggle() {
  return ListTile(
    leading: Icon(
      Icons.brightness_medium,
      color: globalColors.iconDefaultClr,
    ),
    title: Text(
      "Dark Mode",
      style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
    ),
    trailing: Switch(value: true, onChanged: (value) {}),
  );
}
