import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/src/controller/youtube_player_controller.dart';
import 'package:youtube_player_iframe/src/enums/playback_rate.dart';

Future<void> showSettingsBottomSheet(
  BuildContext context,
  final YoutubePlayerController controller,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    context: context,
    builder: (context) {
      return SafeArea(
        left: false,
        top: false,
        right: false,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          width: double.infinity,
          height: 130,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: const Color(0xffB0B6CC)),
                ),
                const SizedBox(
                  height: 16,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     showPlayBackBottomSheet(context, controller);
                //   },
                //   child: const MainItem(
                //     icons: Icons.settings,
                //     mainText: ' Quality',
                //     selectedText: 'Auto(360)',
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // showPlayBackBottomSheet(context, controller);
                  },
                  child: FutureBuilder<double>(
                      future: controller.playbackRate,
                      builder: (context, snapshot) {
                        return MainItem(
                          icons: Icons.settings,
                          mainText: 'PlayBackSpeed',
                          selectedText: '${snapshot.data} ${'x'}',
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showPlayBackBottomSheet(
  BuildContext context,
  bool isFullScreen,
  final YoutubePlayerController controller,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    context: context,
    constraints: BoxConstraints(
      maxWidth: isFullScreen ? 390 : double.infinity,
    ),
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          color: Colors.white,
        ),
        // width: isFullScreen ? 390 : null,

        // height: 166,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: SafeArea(
          left: !isFullScreen,
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: const Color(0xffB0B6CC)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: PlaybackRate.all.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        controller.setPlaybackRate(PlaybackRate.all[index]);
                        Navigator.of(context).pop();
                      },
                      child: FutureBuilder<double>(
                          future: controller.playbackRate,
                          builder: (context, s) {
                            return SubMenuItem(
                              isSelected: s.data == PlaybackRate.all[index],
                              mainText: '${PlaybackRate.all[index]} ${'x'}',
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
