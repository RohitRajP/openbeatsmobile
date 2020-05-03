import 'dart:convert';

import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/tabW/profileTab/profileHomeViewW.dart'
    as profileHomeViewW;
import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/globalVars.dart' as globalVars;
import '../../../globals/actions/globalVarsA.dart' as globalVarsA;
import '../../../globals/globalFun.dart' as globalFun;

class ProfileHomeView extends StatefulWidget {
  @override
  _ProfileHomeViewState createState() => _ProfileHomeViewState();
}

class _ProfileHomeViewState extends State<ProfileHomeView>
    with SingleTickerProviderStateMixin {
  // header mode to show
  String _headerMode;
  // dropDown banner navigator
  final _dropDownBannerNavigatorKey = GlobalKey<NavigatorState>();
  // form key for the textformfields
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();
  // controllers for the tabView
  TabController authTabController;
  // controllers for textfields
  TextEditingController userNameFieldController = new TextEditingController();
  TextEditingController emailFieldController = new TextEditingController();
  TextEditingController passwordFieldController = new TextEditingController();
  // autoValidate flags for the forms
  bool signInFormAutoValidate = false, joinFormAutoValidate = false;
  // is loading flag for http requests
  bool isLoading = false;

  // validator method for the textfields
  void textFieldValidator() {
    // dismissing the keyboard
    FocusScope.of(context).unfocus();
    // checking the current tab
    if (authTabController.index == 0) {
      // validating signIn form
      if (_signInFormKey.currentState.validate())
        signInCallback();
      else {
        setState(() {
          signInFormAutoValidate = true;
        });
      }
    } else {
      if (_joinFormKey.currentState.validate())
        joinCallback();
      else {
        setState(() {
          joinFormAutoValidate = true;
        });
      }
    }
  }

  // signIn callback function
  void signInCallback() async {
    setState(() {
      isLoading = true;
    });
    // fetching values from controllers
    String _userEmail = emailFieldController.text.trim();
    String _userPassword = passwordFieldController.text.trim();

    try {
      // sending http request
      var response = await http.post(globalVars.apiHostAddress + "/auth/login",
          body: {"email": _userEmail, "password": _userPassword});
      // converting response to JSON
      var responseJSON = jsonDecode(response.body);

      // fixing the avatar URL bug
      responseJSON["data"]["avatar"] = "http:" + responseJSON["data"]["avatar"];

      if (responseJSON["status"]) {
        // updating global reference
        globalVarsA
            .updateUserDetails(Map<String, String>.from(responseJSON["data"]));
        // adding token to shared preferences
        globalFun.updateUserDetailsSharedPrefs(
            Map<String, String>.from(responseJSON["data"]));
        // showing dropdown banner
        initiateDropDownBanner(
            "Welcome back, ${responseJSON["data"]["name"]}",
            globalColors.successClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      } else {
        // showing dropdown banner
        initiateDropDownBanner(
            "Apologies, please verify credentials",
            globalColors.errorClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 5));
      }
    } catch (e) {
      print(e);
      globalFun.showToastMessage("Unable to contact server", true,
          globalColors.errorClr, globalColors.darkBgTextClr);
    }
    // refreshing state
    setState(() {
      isLoading = false;
    });
  }

  // join callback function
  void joinCallback() async {
    setState(() {
      isLoading = true;
    });
    // fetching values from controllers
    String _userName = userNameFieldController.text.trim();
    String _userEmail = emailFieldController.text.trim();
    String _userPassword = passwordFieldController.text.trim();

    try {
      // sending http request
      var response = await http
          .post(globalVars.apiHostAddress + "/auth/register", body: {
        "name": _userName,
        "email": _userEmail,
        "password": _userPassword
      });
      // converting response to JSON
      var responseJSON = jsonDecode(response.body);
      if (responseJSON["status"]) {
        // showing dropdown banner
        initiateDropDownBanner(
            "Welcome to OpenBeats, ${responseJSON["data"]["name"]}",
            globalColors.successClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      } else if (responseJSON["data"] ==
          "User with that email id already exist") {
        // showing dropdown banner
        initiateDropDownBanner(
            "An user with the same email Id already exists",
            globalColors.errorClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 5));
      }
    } catch (e) {
      globalFun.showToastMessage("Unable to contact server", true,
          globalColors.errorClr, globalColors.darkBgTextClr);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // setting header mode to show the right widget
    _headerMode = "auth";
    // initiating tabController
    authTabController = TabController(length: 2, vsync: this);
  }

  // initiates the dropdownBanner
  void initiateDropDownBanner(
      String message, Color bgClr, Color txtClr, Duration showDuration) {
    DropdownBanner.showBanner(
        text: message,
        color: bgClr,
        duration: showDuration,
        textStyle: GoogleFonts.openSans(color: txtClr));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownBanner(
      child: Scaffold(
        appBar: profileHomeViewW.appBar(),
        body: profileHomeViewBody(),
      ),
      navigatorKey: _dropDownBannerNavigatorKey,
    );
  }

  // holds the body of ProfileHomeView
  Widget profileHomeViewBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[headerProfileHomeView()],
    );
  }

  // holds the header for the ProfileHomeView
  Widget headerProfileHomeView() {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: (globalVars.userDetails["token"] == null)
          ? authTabW()
          : profileHomeViewW.profileView(context),
    );
  }

  // holds the TabBarView for authTabW
  Widget tabBarViewAuthTabW() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: authTabController,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          _signInWTabBarViewAuthTabW(context),
          _joinWTabBarViewAuthTabW(context),
        ],
      ),
    );
  }

  // holds the authTabW
  Widget authTabW() {
    return Column(
      children: <Widget>[
        _tabBarAuthTabW(authTabController),
        tabBarViewAuthTabW(),
      ],
    );
  }

  // holds the tabBar for authTabW
  Widget _tabBarAuthTabW(TabController controller) {
    return TabBar(
        controller: controller,
        labelColor: globalColors.textActiveClr,
        unselectedLabelColor: globalColors.textDisabledClr,
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(text: "Sign In"),
          Tab(text: "Join"),
        ]);
  }

  // holds the signIn widgets for the authTabW
  Widget _signInWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          profileHomeViewW.signInTabGreetingMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0001,
          ),
          profileHomeViewW.signInTabGreetingSubtitleMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          profileHomeViewW.emailTxtField(
              context, true, emailFieldController, signInFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, true, passwordFieldController, signInFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.actionBtnW(
              context, true, textFieldValidator, isLoading),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.018,
          ),
          profileHomeViewW.fgtPasswordBtn(context),
        ],
      ),
    );
  }

// holds the sign up widgets for the authTabW
  Widget _joinWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _joinFormKey,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          profileHomeViewW.joinTabGreetingMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          profileHomeViewW.userNameTextField(
              context, userNameFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.emailTxtField(
              context, false, emailFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, false, passwordFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.actionBtnW(
              context, false, textFieldValidator, isLoading),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    );
  }
}
