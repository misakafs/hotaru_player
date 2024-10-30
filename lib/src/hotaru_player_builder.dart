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

    widget.controller.update(widget.controller.value.copyWith(
      brightness: brightness,
      volume: volume,
    ));
  }

  @override
  void dispose() {
    ScreenBrightness.instance.resetApplicationScreenBrightness();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!widget.controller.value.backendPlayback && widget.controller.value.playing) {
          widget.controller.play();
        }

        break;

      // case AppLifecycleState.inactive:
      //   // 表示应用处于非活动状态，但仍然可见。这种情况可能发生在用户接收到来电或者应用被另一个临时界面（如弹出对话框）覆盖时
      //   break;
      //
      // case AppLifecycleState.paused:
      //   // 表示应用目前不可见，已经进入后台，但仍然处于内存中。这通常发生在用户切换到另一个应用或者点击了主页按钮
      //   break;
      // case AppLifecycleState.hidden:
      //   // 这个状态在 iOS 设备上使用，表示应用已经被完全遮盖，对用户不可见。这通常发生在用户锁定了屏幕或者应用被其他全屏应用遮盖。
      //   break;
      // case AppLifecycleState.detached:
      //   // 表示应用正在从当前设备上分离，这通常发生在应用即将被销毁时。
      //   // 这个状态在 Android 设备上不常见，因为它通常与操作系统如何管理应用生命周期的方式有关。
      //   break;
      default:
        if (!widget.controller.value.backendPlayback && widget.controller.value.playing) {
          widget.controller.pause();
        }
    }
  }

  @override
  void didChangeMetrics() {
    final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;

    final controller = widget.controller;
    if (physicalSize.width > physicalSize.height) {
      controller.update(controller.value.copyWith(fullscreen: true));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      controller.update(controller.value.copyWith(fullscreen: false));
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
