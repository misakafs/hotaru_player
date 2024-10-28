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

  bool playing = false;
  Duration? timeStamp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = HotaruPlayerController.of(context)!;
    _controller.removeListener(listener);
    _controller.addListener(listener);
    setState(() {
      playing = _controller.value.playing;
    });
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
      onDragStart: (details) {
        setState(() {
          playing = _controller.value.playing;
          timeStamp = details.timeStamp;

          _controller.update(_controller.value.copyWith(
            dragging: true,
          ));

          // 如果已经播放，则暂停
          if (playing) {
            _controller.pause();
          }
        });
      },
      onDragUpdate: (details) async {
        if (timeStamp != null) {
          setState(() {
            timeStamp = null;
          });
        }
        _controller.update(_controller.value.copyWith(
          position: details.timeStamp,
        ));
        await _controller.seek(details.timeStamp);
      },
      onDragEnd: () async {
        if (timeStamp != null) {
          _controller.update(_controller.value.copyWith(
            position: timeStamp,
          ));
          await _controller.seek(timeStamp!);
          setState(() {
            timeStamp = null;
          });
        }
        if (playing) {
          await _controller.play();
        }
        _controller.update(_controller.value.copyWith(
          dragging: false,
        ));
      },
    );
  }
}
