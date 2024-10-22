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
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        break;
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
          allowBackgroundAudioPlaying: true,
          transparentBackground: true,
          disableContextMenu: true,
          supportZoom: false,
          disableHorizontalScroll: true,
          disableVerticalScroll: true,
          allowsInlineMediaPlayback: true,
          allowsAirPlayForMediaPlayback: true,
          allowsPictureInPictureMediaPlayback: true,
          useWideViewPort: false,
          useHybridComposition: true,
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
          })
      ..addJavaScriptHandler(
          handlerName: 'Error',
          callback: (args) {
            log('hotaru player error: ${args.first}');
            controller!.updateValue(
              controller!.value.copyWith(playing: false),
            );
          });
  }

  /// 网页加载完成后
  void onLoadStop() {
    controller!.init(
      url: controller?.option.url,
      poster: controller?.option.poster,
      autoPlay: controller?.option.autoPlay,
      loop: controller?.option.loop,
    );
  }
}
