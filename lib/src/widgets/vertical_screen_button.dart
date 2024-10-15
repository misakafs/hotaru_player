import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 竖屏按钮
class VerticalScreenButton extends StatefulWidget {
  const VerticalScreenButton({
    super.key,
  });

  @override
  State<VerticalScreenButton> createState() => _VerticalScreenButtonState();
}

class _VerticalScreenButtonState extends State<VerticalScreenButton> {
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
        icon: Icon(
          _controller.value.verticalScreen ? Icons.unfold_less_rounded : Icons.unfold_more_rounded,
          color: Colors.white,
          size: _controller.value.verticalScreen ? 30 : 28,
        ),
        onPressed: () => _controller.toggleVerticalScreenMode(),
      ),
    );
  }
}
