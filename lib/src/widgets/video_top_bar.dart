import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

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
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _controller.value.showTopControl ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
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
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
