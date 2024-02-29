// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_iframe_example/new_wdget.dart';
import 'package:youtube_player_iframe_example/video_list_page.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';

const List<String> _videoIds = [
  'tcodrIK2P_I',
  'H5v3kku4y6Q',
  'nPt8bK2gbaU',
  'K18cpp_-gP8',
  'iLnmTe5Q2Qw',
  '_WoCV4c6XOE',
  'KmzdUe0RSJo',
  '6jZDSSZZxjQ',
  'p2lYr3vM_1w',
  '7QUtEmBT_-w',
  '34_PXCzGw1M'
];

Future<void> main() async {
  runApp(YoutubeApp());
}

///
class YoutubeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player IFrame Demo',
      // theme: ThemeData.from(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.deepPurple,
      //     brightness: Brightness.light,
      //   ),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: PlayerDemo(),
      // home: MainApp(),
      // home: YoutubeAppDemo(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
              child: Text('go'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => PlayerDemo())));
              }),
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: true,
        pointerEvents: PointerEvents.none,
        loop: false,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
      ),
    );

    _controller.setFullScreenListener(
      (value) {
        (isFullScreen) {
          log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
        };
      },
    );
    _controller.loadVideoById(videoId: '7DUbn2se7jk');

    // _controller.loadPlaylist(
    //   list: _videoIds,
    //   listType: ListType.playlist,
    //   startSeconds: 136,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const FullscreenYoutubePlayer(videoId: 'xBym4WAZMoA'),
      ),
    );
  }
}

///
class PlayerDemo extends StatefulWidget {
  @override
  State<PlayerDemo> createState() => _PlayerDemoState();
}

class _PlayerDemoState extends State<PlayerDemo> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: true,
        pointerEvents: PointerEvents.none,
        loop: false,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
        enableCaption: false,
      ),
    );

    // _controller.setFullScreenListener(
    //   (value) {
    //     (isFullScreen) {
    //       log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
    //     };
    //   },
    // );

    // _controller.loadPlaylist(
    //   list: _videoIds,
    //   listType: ListType.playlist,z
    //   startSeconds: 136,
    // );

    initFunction();
  }

  initFunction() async {
    await _controller.loadVideoById(videoId: 'VosOOo17GVk');
    //live
    // await _controller.loadVideoById(videoId: 'Tz1G8UbeS3Q');
    //unlisted
    // await _controller.loadVideoById(videoId: 'UItvNh39GPw');
    //upcoming
    // await _controller.loadVideoById(videoId: 'no6dShlnxDg');
    // await _controller.playVideo();
    // _controller.
    // _controller.unMute();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          return YoutubePlayerScaffold(
            isBackVisible: true,
            // width: 100,
            controlsPadding: 20,
            // aspectRatio: 16 / 9,
            // autoFullScreen: true,
            controller: _controller,
            builder: (context, player) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: AspectRatio(aspectRatio: 16 / 9, child: player),
                      ),
                    ),
                    // Visibility(
                    //   // visible: MediaQuery.of(context).orientation == Orientation.portrait,
                    //   visible: true,
                    //   child: Column(
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           showQualityBottomSheet(context);
                    //         },
                    //         child: const ListTile(
                    //           title: Text('this card a '),
                    //         ),
                    //       ),
                    //       InkWell(
                    //           onTap: () {
                    //             showSettingsBottomSheet(context);
                    //           },
                    //           child: const ListTile(title: Text('this card a '))),
                    //       const ListTile(title: Text('this card a ')),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Future<void> showSettingsBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          width: double.infinity,
          height: 166,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: 44,
                  height: 5,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(9), color: const Color(0xffB0B6CC)),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    showQualityBottomSheet(context);
                  },
                  child: const MainItem(
                    icons: Icons.settings,
                    mainText: ' Quality',
                    selectedText: 'Auto(360)',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showQualityBottomSheet(context);
                  },
                  child: const MainItem(
                    icons: Icons.settings,
                    mainText: 'PlayBackSpeed',
                    selectedText: 'Normal',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showQualityBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          width: double.infinity,
          height: 166,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: 44,
                  height: 5,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(9), color: const Color(0xffB0B6CC)),
                ),
                const SizedBox(
                  height: 28,
                ),
                const SubMenuItem(
                  mainText: 'Auto',
                  isSelected: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                const SubMenuItem(
                  mainText: 'FHD (1080P)',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ignore: public_member_api_docs
class MainItem extends StatelessWidget {
  ///
  final String mainText, selectedText;

  ///
  final IconData icons;

  ///
  const MainItem({
    required this.mainText,
    required this.selectedText,
    required this.icons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icons,
            color: const Color(
              0xff0C1547,
            ),
            size: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            mainText,
            style: const TextStyle(
                color: Color(
                  0xff0C1547,
                ),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Text(
            selectedText,
            style: const TextStyle(
                color: Color(
                  0xff7781A7,
                ),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: 16,
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(
              0xff7781A7,
            ),
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ignore: public_member_api_docs
class SubMenuItem extends StatelessWidget {
  ///
  final String mainText;

  ///
  final bool isSelected;

  ///

  ///
  const SubMenuItem({
    required this.mainText,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 25,
        ),
        Visibility(
          visible: isSelected,
          replacement: const SizedBox(
            width: 24,
          ),
          child: const Icon(
            Icons.check,
            weight: 10,
            color: Color(
              0xff0C1547,
            ),
            size: 24,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          mainText,
          style: TextStyle(
              color: const Color(
                0xff0C1547,
              ),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
        ),
        const Spacer(),
      ],
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
            return Slider(
              thumbColor: Colors.white,
              // overlayColor: Colors.accents,
              secondaryActiveColor: Colors.black,
              activeColor: Colors.red,
              inactiveColor: Colors.white,
              value: value,
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
            );
          },
        );
      },
    );
  }
}

///
class YoutubeAppDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: false,
        pointerEvents: PointerEvents.none,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

    _controller.loadPlaylist(
      list: _videoIds,
      listType: ListType.playlist,
      startSeconds: 136,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return YoutubePlayerScaffold(
        isBackVisible: true,
        controlsPadding: MediaQuery.of(context).size.width - 48,
        controller: _controller,
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Youtube Player IFrame Demo'),
              actions: const [VideoPlaylistIconButton()],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (kIsWeb && constraints.maxWidth > 750) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            player,
                            const VideoPositionIndicator(),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Controls(),
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  children: [
                    player,
                    const VideoPositionIndicator(),
                    const Controls(),
                  ],
                );
              },
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetaDataSection(),
          _space,
          SourceInputSection(),
          _space,
          PlayPauseButtonBar(),
          _space,
          const VideoPositionSeeker(),
          _space,
          PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

///
class VideoPlaylistIconButton extends StatelessWidget {
  ///
  const VideoPlaylistIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return IconButton(
      onPressed: () async {
        controller.pauseVideo();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoListPage(),
          ),
        );
        controller.playVideo();
      },
      icon: const Icon(Icons.playlist_play_sharp),
    );
  }
}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

///

