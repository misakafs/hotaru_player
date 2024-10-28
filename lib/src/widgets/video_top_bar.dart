import 'package:flutter/material.dart';
import 'package:hotaru_player/src/widgets/setting_button.dart';

import '../hotaru_player_controller.dart';

const _padding = EdgeInsets.only(top: 4, left: 8, right: 8);
const _fullscreenPadding = EdgeInsets.only(top: 4, left: 28, right: 28);

/// 顶部控件
class VideoTopBar extends StatefulWidget {
  const VideoTopBar({super.key});

  @override
  State<VideoTopBar> createState() => _VideoTopBarState();
}

class _VideoTopBarState extends State<VideoTopBar> {
  late HotaruPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = HotaruPlayerController.of(context)!;
    _controller.removeListener(listener);
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final timeStr = '${now.hour}:${now.minute}';

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !_controller.value.showTopControl,
        child: AnimatedOpacity(
          opacity: _controller.value.showTopControl ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 60,
            padding: _controller.value.fullscreen ? _fullscreenPadding : _padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (_controller.value.fullscreen) {
                      _controller.toggleFullScreenMode();
                      return;
                    }
                    if (_controller.onExit != null) {
                      _controller.onExit!();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                if (_controller.value.fullscreen)
                  Text(
                    timeStr,
                    style: const TextStyle(color: Colors.white),
                  ),
                const SettingButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
