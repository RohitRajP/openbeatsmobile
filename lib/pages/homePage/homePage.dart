import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import 'package:obsmobile/functions/homePageFun.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // temp audioService testing function
  void _audioServiceTest() async {
    Map<String, String> _dataToSend = {
      "title": "Ed Sheeran - Shape of You [Official Video]",
      "thumbnail":
          "https://i.ytimg.com/vi/JGwWNGJdvx8/hqdefault.jpg?sqp=-oaymwEjCPYBEIoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLBDr2laWVr1FOfo6vsZFHCQVOlH5w",
      "duration": "4:24",
      "videoId": "JGwWNGJdvx8",
      "channelName": "Ed Sheeran",
      "channelId": "/channel/UC0C-w0YjGpqDXGB8IHb662A",
      "uploadedOn": "3 years ago4,837,524,821 views",
      "views": "4,837,524,821 views",
      "description":
          "Tickets for the Divide tour here - http://www.edsheeran.com/tourStream or Download Shape Of You: https://atlanti.cr/2singles ..."
    };

    // creating class object
    AudioServiceOps _audioServiceOps = new AudioServiceOps();

    await _audioServiceOps.startSingleSongPlayback(_dataToSend);
  }

  @override
  void initState() {
    super.initState();
    // changing the status bar color
    changeStatusBarColor();
  }

  @override
  Widget build(BuildContext context) {
    print("homePage REBUILT");
    return Scaffold(
      body: _homePageBody(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    // getting required data from data models
    int _currIndex = Provider.of<HomePageData>(context).getBNavBarCurrIndex();
    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        currentIndex: _currIndex,
        onTap: (index) => Provider.of<HomePageData>(context, listen: false)
            .setBNavBarCurrIndex(index),
        items: allDestinations
            .map(
              (destination) => widgets.bottomNavBarItem(destination),
            )
            .toList(),
      ),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return SlidingUpPanel(
      backdropEnabled: true,
      minHeight: 60.0,
      maxHeight: MediaQuery.of(context).size.height,
      parallaxEnabled: true,
      collapsed: _slideUpPanelCollapsed(),
      panel: _slideUpPanel(),
      body: _underneathSlideUpPanel(),
    );
  }

  // holds the collapsed SlideUpPanel
  Widget _slideUpPanelCollapsed() {
    return Container(
      color: GlobalThemes().getAppTheme().accentColor,
      child: Center(
        child: Text("Collapsed SlideUpPanel"),
      ),
    );
  }

  // holds the SlideUpPanel
  Widget _slideUpPanel() {
    return Container(
      color: GlobalThemes().getAppTheme().accentColor,
      child: Center(
        child: Text("SlideUpPanel"),
      ),
    );
  }

  // holds the widget underneath SlideUpPanel
  Widget _underneathSlideUpPanel() {
    return Container(
      child: Center(
        child: Text("Underneath Slide Panel"),
      ),
    );
  }
}
