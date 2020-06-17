import 'package:obsmobile/imports.dart';
import 'package:obsmobile/functions/homePageFun.dart';
import './widgets.dart' as widgets;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // controller for the bottomAppBarSizeTransition
  AnimationController _bottomAppBarAnimController;
  Animation<double> _bottomNavAnimation;

  @override
  void initState() {
    super.initState();
    // changing the status bar color
    changeStatusBarColor();
    // instantiating animation controllers
    _bottomAppBarAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _bottomNavAnimation = CurvedAnimation(
      parent: _bottomAppBarAnimController,
      curve: Curves.ease,
    );
    _bottomAppBarAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("homePage REBUILT");
    return WillPopScope(
      child: KeyboardSizeProvider(
        child: Scaffold(
          key: homePageScaffoldKey,
          body: _homePageBody(),
          bottomNavigationBar: _bottomNavBar(),
        ),
      ),
      onWillPop: () => GlobalFuncs().willPopScopeHandler(),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    // getting required data from data models
    int _currIndex = Provider.of<HomePageData>(context).getBNavBarCurrIndex();
    return SizeTransition(
      sizeFactor: _bottomNavAnimation,
      axisAlignment: -1.0,
      child: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          currentIndex: _currIndex,
          onTap: (index) {
            if (getSlidingUpPanelController().isPanelOpen)
              getSlidingUpPanelController().close();
            Provider.of<HomePageData>(context, listen: false)
                .setBNavBarCurrIndex(index);
          },
          items: allDestinations
              .map(
                (destination) => widgets.bottomNavBarItem(destination),
              )
              .toList(),
        ),
      ),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return Consumer<ScreenHeight>(
      builder: (context, _res, child) {
        return SlidingUpPanel(
          controller: getSlidingUpPanelController(),
          minHeight: (_res.isOpen) ? 0.0 : 70.0,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          collapsed: _slideUpPanelCollapsed(),
          panel: _slideUpPanel(),
          body: _underneathSlideUpPanel(),
          onPanelSlide: (double position) {
            if (position > 0.4)
              _bottomAppBarAnimController.reverse();
            else if (position < 0.4) _bottomAppBarAnimController.forward();
          },
        );
      },
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
        child: IndexedStack(
      index: Provider.of<HomePageData>(context).getBNavBarCurrIndex(),
      children: <Widget>[
        _exploreTabNavigator(),
        _searchTabNavigator(),
        _libraryTabNavigator(),
        _profileTabNavigator()
      ],
    ));
  }

  // holds the navigator for SearchTab
  Widget _searchTabNavigator() {
    return Navigator(onGenerateRoute: (RouteSettings routeSettings) {
      return PageRouteBuilder(
          maintainState: true,
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (BuildContext context, _, __) {
            switch (routeSettings.name) {
              case '/':
                return SearchTab();
              case '/searchNowPage':
                return SearchNowPage();
              default:
                return SearchTab();
            }
          });
    });
  }

  // holds the navigator for exploreTab
  Widget _exploreTabNavigator() {
    return ExploreTab();
  }

  // holds the navigator for the profileTab
  Widget _profileTabNavigator() {
    return ProfileTab();
  }

  // holds the navigator for teh libraryTab
  Widget _libraryTabNavigator() {
    return LibraryTab();
  }
}
