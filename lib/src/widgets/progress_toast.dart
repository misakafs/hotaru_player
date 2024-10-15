import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 进度调节提示框
class ProgressToast extends StatefulWidget {
  const ProgressToast({super.key});

  @override
  State<ProgressToast> createState() => _ProgressToastState();
}

class _ProgressToastState extends State<ProgressToast> {
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
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: IgnorePointer(
          ignoring: true,
          child: Visibility(
            visible: _controller.value.showProgressToast,
            child: Container(
              height: 40,
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('01:10', style: TextStyle(color: Colors.white)),
                  Text('/', style: TextStyle(color: Colors.white)),
                  Text('11:10', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
