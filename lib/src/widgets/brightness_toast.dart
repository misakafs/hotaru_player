import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

/// 亮度调节
class BrightnessToast extends StatefulWidget {
  const BrightnessToast({super.key});

  @override
  State<BrightnessToast> createState() => _BrightnessToastState();
}

class _BrightnessToastState extends State<BrightnessToast> {
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
            visible: _controller.value.showBrightnessToast,
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
                  const Icon(
                    Icons.wb_sunny_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
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
                        value: _controller.value.brightness,
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
