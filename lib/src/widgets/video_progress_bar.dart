import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

class VideoProgressBar extends StatefulWidget {
  const VideoProgressBar({
    super.key,
  });

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
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
    return ProgressBar(
      progress: _controller.value.position,
      buffered: _controller.value.buffered,
      total: _controller.value.duration,
      timeLabelLocation: TimeLabelLocation.none,
      thumbRadius: 6,
      barHeight: 3,
      bufferedBarColor: Colors.white38,
      baseBarColor: Colors.white24,
      thumbColor: Colors.white,
      timeLabelTextStyle: const TextStyle(color: Colors.white),
      timeLabelPadding: 4,
    );
  }
}
