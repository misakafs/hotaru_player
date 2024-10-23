import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'hotaru_player_controller.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  HotaruPlayerController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller = HotaruPlayerController.of(context);

    switch (state) {
      case AppLifecycleState.resumed:
        // 表示应用是可见的，并且处于前台活动状态。用户可以与屏幕交互
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
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = HotaruPlayerController.of(context);

    return IgnorePointer(
      ignoring: true,
      child: InAppWebView(
        key: widget.key,
        initialFile: 'packages/hotaru_player/assets/index.html',
        initialSettings: InAppWebViewSettings(
          userAgent: '',
          mediaPlaybackRequiresUserGesture: false,
          // 允许后台播放
          allowBackgroundAudioPlaying: controller?.value.backendPlayback,
          transparentBackground: true,
          disableContextMenu: true,
          supportZoom: false,
          disableHorizontalScroll: true,
          disableVerticalScroll: true,
          allowsInlineMediaPlayback: true,
          allowsAirPlayForMediaPlayback: true,
          allowsPictureInPictureMediaPlayback: true,
          useWideViewPort: false,
          useHybridComposition: controller?.enableHybridComposition,
        ),
        onWebViewCreated: (webController) => onWebViewCreated(webController),
        onLoadStop: (_, __) => onLoadStop(),
        onConsoleMessage: (webController, message) {
          log('hotaru player console: $message');
        },
      ),
    );
  }

  /// webview 创建
  void onWebViewCreated(InAppWebViewController webController) {
    controller!.updateValue(
      controller!.value.copyWith(webViewController: webController),
    );

    webController
      ..addJavaScriptHandler(
          handlerName: 'Ready',
          callback: (_) {
            controller!.updateValue(
              controller!.value.copyWith(ready: true, playing: true),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Duration',
          callback: (args) {
            final int t = (args.first * 1000.0).floor();
            final d = Duration(milliseconds: t);
            controller!.updateValue(
              controller!.value.copyWith(
                duration: d,
                exceedHour: d.inHours > 0,
              ),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Position',
          callback: (args) {
            final int t = (args.first * 1000.0).floor();
            controller!.updateValue(
              controller!.value.copyWith(position: Duration(milliseconds: t)),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Buffered',
          callback: (args) {
            final int t = (args.first * 1000.0).floor();
            controller!.updateValue(
              controller!.value.copyWith(buffered: Duration(milliseconds: t)),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Ended',
          callback: (_) {
            controller!.updateValue(
              controller!.value.copyWith(playing: false),
            );
            if (controller?.onEnded != null) {
              controller!.onEnded!();
            }
          })
      ..addJavaScriptHandler(
        handlerName: 'Error',
        callback: (args) {
          log('hotaru player error: ${args.first}');
          controller!.updateValue(
            controller!.value.copyWith(playing: false),
          );
        },
      );
  }

  /// 网页加载完成后
  void onLoadStop() {
    if (controller?.onReady != null) {
      controller!.onReady!();
    }
    controller!.init(
      url: controller?.url,
      poster: controller?.poster,
      autoPlay: controller?.autoPlay,
      position: controller?.value.position,
      playbackRate: controller?.value.playbackRate,
      flip: controller?.value.flip,
      aspectRatio: controller?.value.aspectRatio,
    );
  }
}
