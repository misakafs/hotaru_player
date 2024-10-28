import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 迷你进度条
class MiniProgressBar extends StatefulWidget {
  const MiniProgressBar({super.key});

  @override
  State<MiniProgressBar> createState() => _MiniProgressBarState();
}

class _MiniProgressBarState extends State<MiniProgressBar> {
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
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedOpacity(
          opacity: (_controller.value.showBottomControl || _controller.value.fullscreen) ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: ProgressBar(
            progress: _controller.value.position,
            buffered: _controller.value.buffered,
            total: _controller.value.duration,
            timeLabelLocation: TimeLabelLocation.none,
            barCapShape: BarCapShape.square,
            thumbCanPaintOutsideBar: false,
            thumbRadius: 0,
            barHeight: 2,
            bufferedBarColor: Colors.transparent,
            baseBarColor: Colors.white24,
            thumbColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
