import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 全屏按钮
class FullscreenButton extends StatefulWidget {
  const FullscreenButton({
    super.key,
  });

  @override
  State<FullscreenButton> createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<FullscreenButton> {
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
    return Visibility(
      visible: !_controller.value.fullscreen,
      child: IconButton(
        icon: const Icon(
          Icons.fullscreen_rounded,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () => _controller.toggleFullScreenMode(),
      ),
    );
  }
}
