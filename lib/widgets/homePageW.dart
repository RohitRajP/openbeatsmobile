import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../globals/globalVars.dart' as globalVars;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalFun.dart' as globalFun;

// BottomNavBar items for BottomNavBar
List<BottomNavigationBarItem> bottomNavBarItems() {
  // holds list of bottomNavBarItems
  List<BottomNavigationBarItem> bottomNavItemList = [];
  // creating bottomNavBarItems and adding them to the list
  globalWids.bottomNavBarIcons.asMap().forEach(
        (int index, IconData icon) => bottomNavItemList.add(
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 4.0),
              child: Icon(icon),
            ),
            backgroundColor: globalColors.backgroundClr,
            title: Text(globalStrings.bottomNavBarItemLabels[index]),
          ),
        ),
      );
  return bottomNavItemList;
}

// collapsed widget for the SlidingUpPanel
Widget collapsedSlidingUpPanel(
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController) {
  // setting default values
  String audioThumbnail = "placeholder",
      audioTitle = globalStrings.noAudioPlayingString;
  return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        PlaybackState state = snapshot.data;

        if (state != null &&
            state.basicState != BasicPlaybackState.none &&
            state.basicState != BasicPlaybackState.stopped) {
          if (AudioService.currentMediaItem != null &&
              state.basicState != BasicPlaybackState.connecting) {
            // getting thumbNail image
            audioThumbnail = AudioService.currentMediaItem.artUri;
            // getting audioTitle
            audioTitle = AudioService.currentMediaItem.title;
          }
          // if the audio is connecting
          else if (AudioService.currentMediaItem != null &&
              state.basicState == BasicPlaybackState.connecting) {
            // getting thumbNail image
            audioThumbnail = AudioService.currentMediaItem.artUri;
            audioTitle = "Connecting...";
          }
        } else {
          // resetting values
          audioThumbnail = "placeholder";
          audioTitle = globalStrings.noAudioPlayingString;
        }

        return Container(
            decoration: BoxDecoration(
              color: globalColors.backgroundClr,
            ),
            child: nowPlayingCollapsedContent(state, audioThumbnail, audioTitle,
                context, audioServicePlayPause, playPauseAnimationController));
      });
}

// holds the row widget showing now playing media details in collapsed slideUpPanel
Widget nowPlayingCollapsedContent(
    PlaybackState state,
    String audioThumbnail,
    String audioTitle,
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: globalWids.audioThumbnailW(audioThumbnail, context, 0.15, 5.0),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: globalWids.audioTitleW(audioTitle, context, false, false),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: collapsedSlideUpControls(
            state,
            context,
            audioServicePlayPause,
            playPauseAnimationController,
            (audioThumbnail == "placeholder") ? true : false),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
    ],
  );
}

// holds the play controls for the collapsed slide up panel
Widget collapsedSlideUpControls(
    PlaybackState state,
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController,
    bool noAudioPlaying) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        playPauseBtn(state, audioServicePlayPause, playPauseAnimationController,
            noAudioPlaying),
        queueBtn(noAudioPlaying),
      ],
    ),
  );
}

// holds th play&pause btn for collapsed slideUpPanel
Widget playPauseBtn(PlaybackState state, Function audioServicePlayPause,
    AnimationController playPauseAnimationController, bool noAudioPlaying) {
  // decides the animation for the animated icon
  if (state != null &&
      (state.basicState == BasicPlaybackState.paused ||
          state.basicState == BasicPlaybackState.playing)) {
    if (state.basicState == BasicPlaybackState.paused)
      playPauseAnimationController.reverse();
    else
      playPauseAnimationController.forward();
  } else {
    playPauseAnimationController.reverse();
  }
  return IconButton(
    iconSize: 35.0,
    color: (noAudioPlaying)
        ? globalColors.iconDisabledClr
        : globalColors.iconDefaultClr,
    icon: AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: playPauseAnimationController,
    ),
    onPressed: () {
      audioServicePlayPause();
    },
  );
}

// holds the queue button for the collapsed slideUpPanel
Widget queueBtn(bool noAudioPlaying) {
  return IconButton(
    iconSize: 35.0,
    color: (noAudioPlaying)
        ? globalColors.iconDisabledClr
        : globalColors.iconDefaultClr,
    icon: Icon(Icons.queue_music),
    onPressed: () {},
  );
}

//  expanded widget for the SlidingUpPanel
Widget expandedSlidingUpPanel(BehaviorSubject<double> dragPositionSubject,
    AnimationController playPauseAnimationController) {
  // setting default values
  String audioThumbnail = "placeholder",
      audioTitle = globalStrings.noAudioPlayingString,
      audioPlays = "0";
  return StreamBuilder(
    stream: AudioService.playbackStateStream,
    builder: (context, snapshot) {
      PlaybackState state = snapshot.data;
      if (state != null &&
          state.basicState != BasicPlaybackState.none &&
          state.basicState != BasicPlaybackState.stopped) {
        if (AudioService.currentMediaItem != null &&
            state.basicState != BasicPlaybackState.connecting) {
          // getting thumbNail image
          audioThumbnail = AudioService.currentMediaItem.artUri;
          // getting audioTitle
          audioTitle = AudioService.currentMediaItem.title;
          // getting audioViews
          audioPlays = AudioService.currentMediaItem.extras["views"];
        }
        // if the audio is connecting
        else if (AudioService.currentMediaItem != null &&
            state.basicState == BasicPlaybackState.connecting) {
          // getting thumbNail image
          audioThumbnail = AudioService.currentMediaItem.artUri;
          audioTitle = "Please wait\nConnecting...";
          audioPlays = "0";
        }
      } else {
        // resetting values
        audioThumbnail = "placeholder";
        audioTitle = globalStrings.noAudioPlayingString;
        audioPlays = "0 views";
      }
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            slideUpPanelExpandedPanelTitle(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            audioThumbnailW(audioThumbnail, context, 0.80, 5.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.045,
            ),
            audioTitleW(audioTitle, context, false, true),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            slideUpPanelExpandedMediaViews(audioPlays, context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            slideUpPanelExpandedPositionIndicator(AudioService.currentMediaItem,
                state, dragPositionSubject, context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            mainAudioControlsW(
                playPauseAnimationController, state, () {}, context)
          ],
        ),
      );
    },
  );
}

// holds the panel title for the slideUpPanelExpanded
Widget slideUpPanelExpandedPanelTitle() {
  return Container(
    child: Text(
      "NOW PLAYING",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget slideUpPanelExpandedMediaViews(String views, BuildContext context) {
  return Container(
    child: RichText(
      text: TextSpan(
          style: TextStyle(
            color: globalColors.textDisabledClr,
            fontSize: 18.0,
          ),
          children: [
            WidgetSpan(
                child: Icon(
              Icons.play_circle_filled,
              size: 22.0,
              color: globalColors.textDisabledClr,
            )),
            TextSpan(text: " " + views),
          ]),
      textAlign: TextAlign.center,
    ),
  );
}

// holds the thumbnail in audioTile listing view
Widget audioThumbnailW(String thumbnailURL, BuildContext context,
    double sizeFactor, double borderRadius) {
  return Container(
    width: MediaQuery.of(context).size.width * sizeFactor,
    height: MediaQuery.of(context).size.width * sizeFactor,
    decoration: BoxDecoration(boxShadow: [
      new BoxShadow(
        color: Colors.black,
        blurRadius: 3.0,
        offset: new Offset(1.0, 1.0),
      ),
    ], borderRadius: BorderRadius.circular(borderRadius)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: (thumbnailURL != "placeholder")
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: thumbnailURL,
              placeholder: (context, url) => Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          : Image.asset(
              "assets/images/supplementary/dummyimage.png",
              fit: BoxFit.cover,
            ),
    ),
  );
}

// holds the audio title in audioTile listing view
Widget audioTitleW(String title, BuildContext context, bool currentlyPlaying,
    bool shouldScroll) {
  return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            (shouldScroll) ? MediaQuery.of(context).size.width * 0.15 : 0.0,
      ),
      child: (shouldScroll)
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: true,
              physics: BouncingScrollPhysics(),
              child: audioTitleTextW(title, currentlyPlaying, shouldScroll),
            )
          : audioTitleTextW(title, currentlyPlaying, shouldScroll));
}

// holds the text widget for audioTitleW
Widget audioTitleTextW(String title, bool currentlyPlaying, bool shouldScroll) {
  return Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: (shouldScroll) ? 24.0 : 16.0,
      color: (title != globalStrings.noAudioPlayingString)
          ? (currentlyPlaying)
              ? globalColors.textActiveClr
              : globalColors.textDefaultClr
          : globalColors.textDisabledClr,
    ),
  );
}

// holds the audio details in audioTile listing view
Widget audioDetailsW(String views, String duration) {
  return Container(
    margin: EdgeInsets.only(top: 5.0),
    child: Text(duration + " | " + globalFun.reformatViews(views)),
  );
}

// holds the sliderWidget to show the audio play progress slideUpPanelExpanded
Widget slideUpPanelExpandedPositionIndicator(MediaItem mediaItem,
    PlaybackState state, dragPositionSubject, BuildContext context) {
  double seekPos;
  double position;
  double duration;
  String currentTimeStamp;
  String durationInString;
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    ),
    child: StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        if (state != null && state.basicState != BasicPlaybackState.none) {
          position = snapshot.data ?? state.currentPosition.toDouble();
          duration = mediaItem?.duration?.toDouble();
          currentTimeStamp =
              globalFun.getCurrentTimeStamp(state.currentPosition / 1000);
          if (mediaItem != null)
            durationInString = mediaItem.extras["durationString"];
          else
            durationInString = "--:--";
        } else {
          position = 0;
          duration = 10;
          currentTimeStamp = "00:00";
          durationInString = "--:--";
        }
        return Column(
          children: [
            if (duration != null)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0)),
                child: Slider(
                  min: 0.0,
                  max: duration,
                  value: seekPos ?? max(0.0, min(position, duration)),
                  onChanged: (durationInString != "--:--")
                      ? (value) {
                          dragPositionSubject.add(value);
                        }
                      : null,
                  onChangeEnd: (value) {
                    AudioService.seekTo(value.toInt());
                    seekPos = value;
                    dragPositionSubject.add(null);
                  },
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    currentTimeStamp,
                    style: TextStyle(
                      color: (durationInString == "--:--")
                          ? globalColors.textDisabledClr
                          : globalColors.textActiveClr,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    durationInString,
                    style: TextStyle(
                      color: (durationInString == "--:--")
                          ? globalColors.textDisabledClr
                          : globalColors.textActiveClr,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    ),
  );
}

// holds the mainControls for the audio play in the slideUpPanelExpanded
Widget mainAudioControlsW(AnimationController playPauseAnimationController,
    PlaybackState state, Function audioServicePlayPause, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        backward10MainAudioControlsW(state),
        skipPreviousMainAudioControlsW(),
        playPauseMainAudioControlsW(
            playPauseAnimationController, state, audioServicePlayPause),
        skipNextMainAudioControlsW(),
        forward10MainAudioControlsW(state),
      ],
    ),
  );
}

// holds the playPauseIcon for the mainAudioControlsW in slideUpPanelExpanded
Widget playPauseMainAudioControlsW(
    AnimationController playPauseAnimationController,
    PlaybackState state,
    Function audioServicePlayPause) {
  bool noAudioPlaying = true;
  if (state != null &&
      (state.basicState == BasicPlaybackState.paused ||
          state.basicState == BasicPlaybackState.playing)) {
    // setting no audioPlaying to false
    noAudioPlaying = false;
    if (state.basicState == BasicPlaybackState.paused)
      playPauseAnimationController.reverse();
    else
      playPauseAnimationController.forward();
  } else {
    playPauseAnimationController.reverse();
  }
  return Container(
      child: ClipOval(
    child: Material(
      color: (noAudioPlaying)
          ? globalColors.iconDisabledClr
          : globalColors.iconActiveClr, // button color
      child: GestureDetector(
        child: SizedBox(
            width: 70,
            height: 70,
            child: Center(
              child: AnimatedIcon(
                size: 40.0,
                icon: AnimatedIcons.play_pause,
                progress: playPauseAnimationController,
                color: globalColors.iconActiveClr,
              ),
            )),
        onTap: (noAudioPlaying)
            ? null
            : () {
                audioServicePlayPause();
              },
      ),
    ),
  ));
}

// holds the skipPrevious button for the mainAudioControlsW in slideUpPanelExpanded
Widget skipPreviousMainAudioControlsW() {
  return Container(
    child: IconButton(
      iconSize: 45.0,
      color: globalColors.iconDefaultClr,
      icon: Icon(Icons.skip_previous),
      onPressed: null,
    ),
  );
}

// holds the skipNext button for the mainAudioControlsW in slideUpPanelExpanded
Widget skipNextMainAudioControlsW() {
  return Container(
    child: IconButton(
      iconSize: 45.0,
      color: globalColors.iconDefaultClr,
      icon: Icon(Icons.skip_next),
      onPressed: null,
    ),
  );
}

// holds the forward10 button for the mainAudioControlsW in slideUpPanelExpanded
Widget forward10MainAudioControlsW(PlaybackState state) {
  return Container(
    child: IconButton(
      iconSize: 35.0,
      color: (state != null &&
              (state.basicState == BasicPlaybackState.playing ||
                  state.basicState == BasicPlaybackState.paused))
          ? globalColors.iconDefaultClr
          : globalColors.iconDisabledClr,
      icon: Icon(Icons.forward_10),
      onPressed: () {
        // checking if audio is playing
        if (state != null && (state.basicState == BasicPlaybackState.playing) ||
            state.basicState == BasicPlaybackState.paused) {
          // getting current position of audio
          int currPosition = state.currentPosition;
          // seeking audioService to 10 seconds behind the current position
          AudioService.seekTo(currPosition + 10000);
        }
      },
    ),
  );
}

// holds the backward10 button for the mainAudioControlsW in slideUpPanelExpanded
Widget backward10MainAudioControlsW(PlaybackState state) {
  return Container(
    child: IconButton(
      iconSize: 35.0,
      color: (state != null &&
              (state.basicState == BasicPlaybackState.playing ||
                  state.basicState == BasicPlaybackState.paused))
          ? globalColors.iconDefaultClr
          : globalColors.iconDisabledClr,
      icon: Icon(Icons.replay_10),
      onPressed: () {
        // checking if audio is playing
        if (state != null && (state.basicState == BasicPlaybackState.playing) ||
            state.basicState == BasicPlaybackState.paused) {
          // getting current position of audio
          int currPosition = state.currentPosition;
          // seeking audioService to 10 seconds behind the current position
          AudioService.seekTo(currPosition - 10000);
        }
      },
    ),
  );
}
