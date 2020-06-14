import '../../imports.dart';

class ThemeComponents {
  // holds the theme data for the entire application
  ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF14161C),
    appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
        textTheme: TextTheme(
            headline6: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ))),
    primaryColor: Color(0xFFF32C2C),
    accentColor: Colors.redAccent,
    bottomAppBarColor: Color(0xFF212229),
  );
  // holds the theme data for the toast messages
  Map<String, dynamic> toastThemeData = {
    "backgroundColor": Colors.blue,
    "position": ToastPosition.bottom,
    "duration": Duration(seconds: 5),
    "textPadding": EdgeInsets.all(20.0),
    "dismissOtherOnShow": true,
  };
}
