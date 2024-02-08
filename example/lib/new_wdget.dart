// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/src/widgets/widgets.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// A widget the scaffolds the [YoutubePlayer] so that it can be moved around easily in the view
/// and handles the fullscreen functionality.
class YoutubePlayerScaffoldL extends StatefulWidget {
  /// Creates [YoutubePlayerScaffoldL].
  const YoutubePlayerScaffoldL({
    super.key,
    required this.builder,
    required this.controller,
    this.aspectRatio = 16 / 9,
    this.function,
    this.autoFullScreen = true,
    required this.isBackVisible,
    required this.width,
    this.isLive,
    this.liveStartTime,
    this.defaultOrientations = DeviceOrientation.values,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.fullscreenOrientations = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.lockedOrientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.enableFullScreenOnVerticalDrag = true,
    this.backgroundColor,
    @Deprecated('Unused parameter. Use `YoutubePlayerParam.userAgent` instead.') this.userAgent,
  });

  /// Builds the child widget.
  final Widget Function(BuildContext context, Widget player) builder;

  /// The player controller.
  final YoutubePlayerController controller;

  final double width;

  final DateTime? liveStartTime;
  final bool? isLive;

  final bool isBackVisible;

  /// The aspect ratio of the player.
  ///
  /// The value is ignored on fullscreen mode.
  final double aspectRatio;

  /// Whether the player should be fullscreen on device orientation changes.
  final bool autoFullScreen;

  /// The default orientations for the device.
  final List<DeviceOrientation> defaultOrientations;

  /// The orientations that are used when in fullscreen.
  final List<DeviceOrientation> fullscreenOrientations;

  /// The orientations that are used when not in fullscreen and auto rotate is disabled.
  final List<DeviceOrientation> lockedOrientations;

  final void Function()? function;

  /// Enables switching full screen mode on vertical drag in the player.
  ///
  /// Default is true.
  final bool enableFullScreenOnVerticalDrag;

  /// Which gestures should be consumed by the youtube player.
  ///
  /// This property is ignored in web.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// The background color of the [WebView].
  final Color? backgroundColor;

  /// The value used for the HTTP User-Agent: request header.
  ///
  /// When null the platform's webview default is used for the User-Agent header.
  ///
  /// By default `userAgent` is null.
  final String? userAgent;

  @override
  State<YoutubePlayerScaffoldL> createState() => _YoutubePlayerScaffoldLState();
}

class _YoutubePlayerScaffoldLState extends State<YoutubePlayerScaffoldL> {
  late final GlobalObjectKey _playerKey;
  late Timer _hideControlsTimer;
  @override
  void initState() {
    super.initState();
    timerStart();
    _playerKey = GlobalObjectKey(widget.controller);
  }

  timerStart() {
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      // if(widget.controller)
      widget.controller.update(isControlsVisible: false);
      log('calling timer');
    });
  }

  _toggleControlles() {
    if (widget.controller.value.isControlsVisible) {
      widget.controller.update(isControlsVisible: false);
    } else {
      timerStart();
      widget.controller.update(isControlsVisible: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = KeyedSubtree(
      key: _playerKey,
      child: Builder(builder: (context) {
        return Container(
          // width: widget.width,
          color: Colors.black,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                SizedBox(width: double.infinity, height: double.infinity),
                Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: widget.controller,
                      aspectRatio: widget.aspectRatio,
                      gestureRecognizers: widget.gestureRecognizers,
                      enableFullScreenOnVerticalDrag: widget.enableFullScreenOnVerticalDrag,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                ),
                YoutubeValueBuilder(builder: (context, value) {
                  return GestureDetector(
                    onTap: () {
                      _toggleControlles();
                      log('this is happening');
                    },
                    child: Visibility(
                      // visible: value.playerState == PlayerState.paused,
                      child: AnimatedContainer(
                          width: double.infinity,
                          height: double.infinity,
                          duration: const Duration(milliseconds: 300),
                          // color: _controller.value.isControlsVisible ? Colors.black.withAlpha(150) : Colors.transparent,
                          color: value.isControlsVisible
                              ? Colors.black.withAlpha(120)
                              : value.playerState == PlayerState.paused
                                  ? Colors.black.withAlpha(160)
                                  : Colors.transparent
                          // color: Colors.red,
                          ),
                    ),
                  );
                }),
                Positioned(
                  right: 0,
                  bottom: 0,
                  left: 0,
                  top: 0,
                  child: YoutubeValueBuilder(
                    builder: (context, value) {
                      return Visibility(
                        visible: value.isControlsVisible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // TODO
                            // for the seek we need to change to seek bar and player durarion also
                            // so seek multiple times is holded
                            StreamBuilder<YoutubeVideoState>(
                              initialData: const YoutubeVideoState(),
                              stream: widget.controller.videoStateStream,
                              builder: (context, snapshot) {
                                final position = snapshot.data?.position.inSeconds ?? 0;

                                return IconButton(
                                  icon: const Icon(
                                      color: Colors.white,
                                      size: 30,
                                      // Icons.skip_previous,
                                      Icons.keyboard_double_arrow_left),
                                  onPressed: () async {
                                    // if (position >= 10) {
                                    await widget.controller.seekTo(seconds: position - 10);
                                    await widget.controller.playVideo();

                                    // }
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            IconButton(
                              icon: Icon(
                                color: Colors.white,
                                size: 30,
                                value.playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
                              ),
                              onPressed: () {
                                log('tapping');
                                value.playerState == PlayerState.playing
                                    ? context.ytController.pauseVideo()
                                    : context.ytController.playVideo();
                              },
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            StreamBuilder<YoutubeVideoState>(
                              initialData: YoutubeVideoState(),
                              stream: widget.controller.videoStateStream,
                              builder: (context, snapshot) {
                                var position = snapshot.data?.position.inSeconds ?? 0;
                                // var lastPosition = 0;
                                // var pressedCount = 0;
                                return IconButton(
                                  icon: const Icon(
                                      color: Colors.white,
                                      size: 30,
                                      // Icons.skip_next,
                                      Icons.keyboard_double_arrow_right),
                                  onPressed: () async {
                                    await widget.controller.seekTo(seconds: (position + 10));
                                    await widget.controller.playVideo();
                                    // pressedCount += 1;
                                    // final duration = context.ytController.metadata.duration.inSeconds;
                                    // if (lastPosition > position) {
                                    //   widget.controller.seekTo(seconds: (lastPosition + 10));
                                    //   lastPosition = position + 10;
                                    // } else {
                                    //   widget.controller.seekTo(seconds: (position + 10));
                                    //   lastPosition = position +10;
                                    // }

                                    // if ((position - lastPosition) <= 2) {
                                    //   widget.controller
                                    //       .seekTo(seconds: (position + (10 * pressedCount)).toDouble());
                                    // }else{
                                    //    widget.controller
                                    //       .seekTo(seconds: (position + 10).toDouble());
                                    // }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  top: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: YoutubeValueBuilder(builder: (context, value) {
                      return Builder(builder: (context) {
                        return SizedBox(
                          // width: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width - widget.width,
                          child: Visibility(
                            visible: value.isControlsVisible,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(11, 12, 11, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    replacement: SizedBox(
                                      width: 20,
                                    ),
                                    visible: widget.isBackVisible,
                                    child: InkWell(
                                      onTap: widget.function,
                                      child: Container(
                                        width: 31,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: const Color(0xff263047).withOpacity(.8),
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.arrow_back),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),

                                  //!
                                  StreamBuilder<YoutubeVideoState>(
                                      stream: context.ytController.videoStateStream,
                                      builder: (context, snapshot) {
                                        final position = snapshot.data?.position.inSeconds ?? 0;
                                        bool showLiveTag() {
                                          if (widget.liveStartTime == null || !(widget.isLive ?? false)) {
                                            return false;
                                          }

                                          return widget.liveStartTime!.second < position;
                                        }

                                        return Visibility(
                                          visible: showLiveTag(),
                                          child: Container(
                                            width: 62.58,
                                            height: 23.93,
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 9.93, vertical: 4.96),
                                            decoration: ShapeDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.54, -0.84),
                                                end: Alignment(0.54, 0.84),
                                                colors: [Color(0xFFEE6623), Color(0xFFEE229C)],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(13.24),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 6.62),
                                                Text(
                                                  'Live',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9.93,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0.14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  InkWell(
                                    child: const Icon(
                                      color: Colors.white,
                                      size: 30,
                                      Icons.settings,
                                    ),
                                    onTap: () {
                                      showSettingsBottomSheet(context, widget.controller);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                ),
                YoutubeValueBuilder(builder: (context, value) {
                  return Positioned.fill(
                      // left: 0,
                      // right: 0,
                      // top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: value.isControlsVisible,
                          child: Builder(builder: (context) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width - widget.width,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 25),
                                          child: StreamBuilder<YoutubeVideoState>(
                                            initialData: const YoutubeVideoState(),
                                            stream: widget.controller.videoStateStream,
                                            builder: (context, snapshot) {
                                              final position = snapshot.data?.position.inSeconds ?? 0;
                                              final duration =
                                                  context.ytController.metadata.duration.inSeconds;

                                              String intToTime(int value) {
                                                int h, m, s;
                                                String hh, mm, ss, r;

                                                h = value ~/ 3600;

                                                m = ((value - h * 3600)) ~/ 60;

                                                s = value % 60;

                                                hh = h.toString().padLeft(2, '0');
                                                mm = m.toString().padLeft(2, '0');
                                                ss = s.toString().padLeft(2, '0');

                                                if (hh == '00') {
                                                  r = '$mm:$ss';
                                                } else {
                                                  r = '$hh:$mm:$ss';
                                                }
                                                return r;
                                              }

                                              return Text(
                                                '${intToTime(position)} / ${intToTime(duration)}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600),
                                              );
                                            },
                                          ),
                                        ),
                                        // Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 18),
                                          child: InkWell(
                                            child: Icon(
                                              color: Colors.white,
                                              size: 30,
                                              value.fullScreenOption.enabled
                                                  ? Icons.fullscreen_exit
                                                  : Icons.fullscreen,
                                            ),
                                            onTap: () {
                                              value.fullScreenOption.enabled
                                                  ? widget.controller.exitFullScreen()
                                                  : widget.controller.enterFullScreen();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: SizedBox(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width - widget.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: const VideoPositionSeeker(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ));
                })
              ],
            ),
          ),
        );
      }),
    );

    return YoutubePlayerControllerProvider(
      controller: widget.controller,
      child: kIsWeb
          ? widget.builder(context, player)
          : YoutubeValueBuilder(
              controller: widget.controller,
              buildWhen: (o, n) => o.fullScreenOption != n.fullScreenOption,
              builder: (context, value) {
                return _FullScreen(
                  auto: widget.autoFullScreen,
                  defaultOrientations: widget.defaultOrientations,
                  fullscreenOrientations: widget.fullscreenOrientations,
                  lockedOrientations: widget.lockedOrientations,
                  fullScreenOption: value.fullScreenOption,
                  child: Builder(
                    builder: (context) {
                      if (value.fullScreenOption.enabled) return Center(child: player);
                      return widget.builder(context, player);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});
  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return StreamBuilder<YoutubeVideoState>(
      stream: context.ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inSeconds ?? 0;
        final duration = context.ytController.metadata.duration.inSeconds;
        value = position == 0 || duration == 0 ? 0 : position / duration;
        return StatefulBuilder(
          builder: (context, setState) {
            return SliderTheme(
              data: const SliderThemeData(
                  thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6,
              )),
              child: Slider(
                thumbColor: const Color(0xffFF6028),
                // overlayColor: Colors.accents,
                secondaryActiveColor: Colors.black,

                activeColor: const Color(0xffFF6028),
                inactiveColor: const Color(0xffF4F1FF).withOpacity(.5),
                value: value <= 1 ? value : 1,
                onChanged: (positionFraction) {
                  value = positionFraction;
                  setState(() {});
                  context.ytController.seekTo(
                    seconds: (value * duration).toDouble(),
                    allowSeekAhead: true,
                  );
                },
                min: 0,
                max: 1,
              ),
            );
          },
        );
      },
    );
  }
}

class _FullScreen extends StatefulWidget {
  const _FullScreen({
    required this.fullScreenOption,
    required this.defaultOrientations,
    required this.fullscreenOrientations,
    required this.lockedOrientations,
    required this.child,
    required this.auto,
  });

  final FullScreenOption fullScreenOption;
  final List<DeviceOrientation> defaultOrientations;
  final List<DeviceOrientation> fullscreenOrientations;
  final List<DeviceOrientation> lockedOrientations;
  final Widget child;
  final bool auto;

  @override
  State<_FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<_FullScreen> with WidgetsBindingObserver {
  Orientation? _previousOrientation;

  @override
  void initState() {
    super.initState();

    if (widget.auto) WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(_deviceOrientations);
    SystemChrome.setEnabledSystemUIMode(_uiMode);
  }

  @override
  void didUpdateWidget(_FullScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.fullScreenOption != widget.fullScreenOption) {
      SystemChrome.setPreferredOrientations(_deviceOrientations);
      SystemChrome.setEnabledSystemUIMode(_uiMode);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final orientation = MediaQuery.of(context).orientation;
    final controller = YoutubePlayerControllerProvider.of(context);
    final isFullScreen = controller.value.fullScreenOption.enabled;

    if (_previousOrientation == orientation) return;

    if (!isFullScreen && orientation == Orientation.landscape) {
      controller.enterFullScreen(lock: false);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    _previousOrientation = orientation;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleFullScreenBackAction,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (widget.auto) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<DeviceOrientation> get _deviceOrientations {
    final fullscreen = widget.fullScreenOption;

    if (!fullscreen.enabled && fullscreen.locked) {
      return widget.lockedOrientations;
    } else if (fullscreen.enabled) {
      return widget.fullscreenOrientations;
    }

    return widget.defaultOrientations;
  }

  SystemUiMode get _uiMode {
    return widget.fullScreenOption.enabled ? SystemUiMode.immersive : SystemUiMode.edgeToEdge;
  }

  Future<bool> _handleFullScreenBackAction() async {
    if (mounted && widget.fullScreenOption.enabled) {
      YoutubePlayerControllerProvider.of(context).exitFullScreen();
      return false;
    }

    return true;
  }
}
