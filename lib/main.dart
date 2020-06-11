import './screens/index.dart' as indexScreen;
import './imports.dart';

void main() => runApp(
      ChangeNotifierProvider<ApplicationTheme>(
        create: (_) => ApplicationTheme(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      theme: Provider.of<ApplicationTheme>(context).getCurrentTheme(),
      home: indexScreen.IndexScreen(),
    );
  }
}
