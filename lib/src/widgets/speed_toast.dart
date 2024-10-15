import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 倍速调节
class SpeedToast extends StatefulWidget {
  const SpeedToast({super.key});

  @override
  State<SpeedToast> createState() => _SpeedToastState();
}

class _SpeedToastState extends State<SpeedToast> {
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
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: IgnorePointer(
          ignoring: true,
          child: Visibility(
            visible: _controller.value.showSpeedToast,
            child: Container(
              height: 48,
              width: 124,
              padding: const EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.fast_forward_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '倍速播放中',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
