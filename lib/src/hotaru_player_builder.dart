import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'hotaru_player.dart';
import 'hotaru_player_controller.dart';

class HotaruPlayerBuilder extends StatefulWidget {
  final HotaruPlayerController controller;

  final Widget Function(BuildContext context, Widget player) builder;

  const HotaruPlayerBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  State<HotaruPlayerBuilder> createState() => _HotaruPlayerBuilderState();
}

class _HotaruPlayerBuilderState extends State<HotaruPlayerBuilder> with WidgetsBindingObserver {
  final GlobalKey playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  Future<void> init() async {
    // 获取屏幕亮度
    final brightness = await ScreenBrightness.instance.application;
    // 获取音量
    final volume = await FlutterVolumeController.getVolume();

    widget.controller.updateValue(widget.controller.value.copyWith(
      brightness: brightness,
      volume: volume,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;

    final controller = widget.controller;
    if (physicalSize.width > physicalSize.height) {
      controller.updateValue(controller.value.copyWith(fullscreen: true));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      controller.updateValue(controller.value.copyWith(fullscreen: false));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final size = MediaQuery.sizeOf(context);

    /// 全屏
    final player = SizedBox(
      key: playerKey,
      height: orientation == Orientation.landscape ? size.height : null,
      child: PopScope(
        canPop: !widget.controller.value.fullscreen,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final controller = widget.controller;
          if (controller.value.fullscreen) {
            widget.controller.toggleFullScreenMode();
          }
        },
        child: HotaruPlayer(controller: widget.controller),
      ),
    );

    /// 小屏
    final child = widget.builder(context, player);

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return player;
        }
        return child;
      },
    );
  }
}
