import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hotaru_player/src/hotaru_player_value.dart';

import 'hotaru_player_controller.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  HotaruPlayerController? controller;

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
    controller!.update(
      controller!.value.copyWith(webViewController: webController),
    );

    webController
      ..addJavaScriptHandler(
          handlerName: 'Ready',
          callback: (_) {
            controller!.update(
              controller!.value.copyWith(
                ready: true,
                playing: true,
              ),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Duration',
          callback: (args) {
            final int t = (args.first * 1000.0).floor();
            final d = Duration(milliseconds: t);
            controller!.update(
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
            controller!.update(
              controller!.value.copyWith(position: Duration(milliseconds: t)),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Buffered',
          callback: (args) {
            final int t = (args.first * 1000.0).floor();
            controller!.update(
              controller!.value.copyWith(buffered: Duration(milliseconds: t)),
            );
          })
      ..addJavaScriptHandler(
          handlerName: 'Ended',
          callback: (_) {
            controller!.update(
              controller!.value.copyWith(playing: false),
            );

            if (controller?.onEnded != null) {
              controller!.onEnded!();
            }

            if (controller?.value.playMode == PlayMode.loop) {
              controller!.update(
                controller!.value.copyWith(playing: true),
              );
              controller?.play();
              return;
            }
            if (controller?.value.playMode == PlayMode.next && controller?.onNext != null) {
              controller!.onNext!();
            }
          })
      ..addJavaScriptHandler(
        handlerName: 'Error',
        callback: (args) {
          log('hotaru player error: ${args.first}');
          controller!.update(
            controller!.value.copyWith(playing: false),
          );
          if (controller?.onError != null) {
            Exception exception = Exception('hotaru player error: ${args.first}');
            StackTrace currentStackTrace = StackTrace.current;
            controller?.onError!(exception, currentStackTrace);
          }
        },
      );
  }

  /// 网页加载完成后
  void onLoadStop() {
    if (controller?.onReady != null) {
      controller!.onReady!();
    }
    controller!.init(
      url: controller?.value.url,
      poster: controller?.value.poster,
      autoPlay: controller?.value.autoPlay,
      position: controller?.value.position,
      playbackRate: controller?.value.playbackRate,
      flip: controller?.value.flip,
      aspectRatio: controller?.value.aspectRatio,
    );
  }
}
