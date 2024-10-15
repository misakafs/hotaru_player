import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 音量调节
class VolumeToast extends StatefulWidget {
  const VolumeToast({super.key});

  @override
  State<VolumeToast> createState() => _VolumeToastState();
}

class _VolumeToastState extends State<VolumeToast> {
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
            visible: _controller.value.showVolumeToast,
            child: Container(
              height: 50,
              width: 174,
              padding: const EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 2),
                        trackShape: const RectangularSliderTrackShape(),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: 0.5,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (double value) {},
                      ),
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
