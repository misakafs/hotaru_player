import 'package:flutter/material.dart';
import 'package:hotaru_player/src/widgets/time_label.dart';
import 'package:hotaru_player/src/widgets/video_progress_bar.dart';

import '../hotaru_player_controller.dart';
import 'fullscreen_button.dart';
import 'play_pause_button.dart';

/// 底部控件
class VideoBottomBar extends StatefulWidget {
  const VideoBottomBar({super.key});

  @override
  State<VideoBottomBar> createState() => _VideoBottomBarState();
}

class _VideoBottomBarState extends State<VideoBottomBar> {
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

  Widget _buildFullscreenBottomBar() {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.black.withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: TimeLabel(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: VideoProgressBar(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PlayPauseButton(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '倍速',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNormalBottomBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.black.withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: const Row(
        children: [
          PlayPauseButton(),
          Expanded(
            child: VideoProgressBar(),
          ),
          SizedBox(width: 16),
          TimeLabel(),
          SizedBox(width: 4),
          FullscreenButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _controller.value.showBottomControl ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: _controller.value.fullscreen ? _buildFullscreenBottomBar() : _buildNormalBottomBar(),
      ),
    );
  }
}
