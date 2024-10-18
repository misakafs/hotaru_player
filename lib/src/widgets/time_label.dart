import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';
import '../utils/hotaru_utils.dart';

/// 时间标签
class TimeLabel extends StatefulWidget {
  final double fontSize;

  const TimeLabel({
    super.key,
    this.fontSize = 10,
  });

  @override
  State<TimeLabel> createState() => _TimeLabelState();
}

class _TimeLabelState extends State<TimeLabel> {
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
    return IgnorePointer(
      ignoring: true,
      child: Row(
        children: [
          Text(
            HotaruUtils.formatDuration(_controller.value.position, _controller.value.exceedHour),
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 1),
          Text(
            '/',
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 1),
          Text(
            HotaruUtils.formatDuration(_controller.value.duration, _controller.value.exceedHour),
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
