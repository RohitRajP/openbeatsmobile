import 'package:obsmobile/imports.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';

// holds the bottomNavBarItem for the homePage
BottomNavigationBarItem bottomNavBarItem(Destination destination) {
  return BottomNavigationBarItem(
      icon: Icon(destination.icon),
      title: Text(destination.title),
      backgroundColor: destination.color);
}

// holds the widget to show in SlidingUpPanelCollapsed when no audio is playing
Widget slidingUpPanelCollapsedDefault() {
  return Center(
    child: Container(
      height: 35.0,
      child: FlareActor(
        "assets/flareAssets/logoanimwhite.flr",
        animation: "rotate",
      ),
    ),
  );
}

// holds the nowPlayingThumbnailHolder
Widget nowPlayingThumbnailHolder(String artUrl, BuildContext context) {
  return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.height * 0.4,
      child: cachedNetworkImageW(artUrl));
}

// holds the nowPlayingTitleHolder
Widget nowPlayingTitleHolder(MediaItem _currMediaItem) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        (_currMediaItem != null)
            ? _currMediaItem.title
            : "Welcome to\nOpenBeats",
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
      ));
}

// holds the play pause icon in the collapsed slideUpPanel
Widget collapsedPanelSlideUpPanel() {
  // sets the parameters
  Icon _icon;
  AudioProcessingState _processingState;
  if (AudioService.playbackState != null) {
    _processingState = AudioService.playbackState.processingState;
    if (AudioService.playbackState.playing)
      _icon = Icon(Icons.pause);
    else
      _icon = Icon(Icons.play_arrow);
  } else
    _icon = Icon(Icons.play_arrow);

  return IconButton(
      icon: (_processingState != AudioProcessingState.connecting ||
              _processingState != AudioProcessingState.buffering)
          ? _icon
          : Container(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(),
            ),
      onPressed: () {
        if (AudioService.playbackState != null) {
          if (AudioService.playbackState.playing)
            AudioService.pause();
          else
            AudioService.play();
        }
      });
}
