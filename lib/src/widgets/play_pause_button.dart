import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({
    super.key,
  });

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
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
    return IconButton(
      icon: Icon(
        _controller.value.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
        size: 32,
      ),
      onPressed: () => _controller.togglePlayPause(),
    );
  }
}
