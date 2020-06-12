// package imports
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:provider/provider.dart';
export 'package:flutter/services.dart';
export 'package:sliding_up_panel/sliding_up_panel.dart';
export 'dart:async';
export 'package:audio_service/audio_service.dart';
import 'package:audio_service/audio_service.dart';
export 'package:just_audio/just_audio.dart';
export 'package:ota_update/ota_update.dart';
export 'package:http/http.dart';
export 'dart:convert';
export 'package:package_info/package_info.dart';
export 'package:oktoast/oktoast.dart';

// file imports
export 'package:openbeatsmobile/models/app/state.dart';
export 'package:openbeatsmobile/components/bottomNavDestinations.dart';
export 'package:openbeatsmobile/services/audio/streaming.dart';
export 'package:openbeatsmobile/screens/pages/explore/explorePage.dart';
export 'package:openbeatsmobile/screens/pages/library/libraryPage.dart';
export 'package:openbeatsmobile/screens/pages/profile/profilePage.dart';
export 'package:openbeatsmobile/screens/pages/search/searchPage.dart';
export 'package:openbeatsmobile/util/indexPage/indexPageFunc.dart';
export 'package:openbeatsmobile/util/updateFuncs.dart';
export 'package:openbeatsmobile/screens/pages/profile/components.dart';
export 'package:openbeatsmobile/models/app/theme.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);
