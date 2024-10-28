import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'hotaru_player_value.dart';

class HotaruPlayerController extends ValueNotifier<HotaruPlayerValue> {
  /// 启用混合渲染
  /// 默认: true
  final bool enableHybridComposition;

  final VoidCallback? onReady;
  final VoidCallback? onEnded;
  final VoidCallback? onNext;
  final VoidCallback? onExit;
  final ErrorCallback? onError;

  HotaruPlayerController({
    String url = '',
    String poster = '',
    bool autoPlay = true,
    bool backendPlayback = true,
    Duration position = Duration.zero,
    PlayMode playMode = PlayMode.stop,
    double playbackRate = 1.0,
    double speedRate = 2.0,
    Flip flip = Flip.normal,
    String aspectRatio = '',
    //
    this.enableHybridComposition = true,
    this.onReady,
    this.onEnded,
    this.onNext,
    this.onExit,
    this.onError,
  }) : super(
          HotaruPlayerValue(
            url: url,
            poster: poster,
            autoPlay: autoPlay,
            backendPlayback: backendPlayback,
            position: position,
            playMode: playMode,
            playbackRate: playbackRate,
            speedRate: speedRate,
            flip: flip,
            aspectRatio: aspectRatio,
          ),
        );

  @override
  void dispose() {
    value.webViewController?.dispose();
    super.dispose();
  }

  static HotaruPlayerController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHotaruPlayer>()?.controller;
  }

  Future<void> _evaluateJavascript(String source) async {
    if (value.ready) {
      return value.webViewController?.evaluateJavascript(source: source);
      return;
    }
    log('the player is not ready');
  }

  void update(HotaruPlayerValue newValue) => value = newValue;

  /// 初始化网页播放器
  Future<void> init({
    String? url,
    String? poster,
    bool? autoPlay,
    Duration? position,
    PlayMode? playMode,
    double? playbackRate,
    Flip? flip,
    String? aspectRatio,
  }) async {
    if (url == null || url.isEmpty) {
      return;
    }

    final Map<String, dynamic> m = {
      'url': url,
    };

    if (poster != null && poster.isNotEmpty) {
      m['poster'] = poster;
    }

    if (autoPlay != null) {
      m['autoPlay'] = autoPlay;
    }

    if (playMode != null) {
      if (playMode == PlayMode.loop) {
        m['loop'] = true;
      } else {
        m['loop'] = false;
      }
    }

    if (position != null) {
      m['seek'] = position.inMilliseconds.toDouble() / 1000;
    }

    if (playbackRate != null) {
      m['playbackRate'] = playbackRate;
    }

    if (flip != null) {
      m['flip'] = flip.value;
    }

    if (aspectRatio != null) {
      m['aspectRatio'] = aspectRatio;
    }

    final obj = const JsonEncoder().convert(m);

    return value.webViewController?.evaluateJavascript(source: 'init($obj)');
  }

  /// 播放器播放
  Future<void> play() {
    return _evaluateJavascript('play()');
  }

  /// 播放器暂停
  Future<void> pause() {
    return _evaluateJavascript('pause()');
  }

  /// 切换播放和暂停
  Future<void> togglePlayPause() async {
    update(value.copyWith(playing: !value.playing));
    if (value.playing) {
      return play();
    } else {
      return pause();
    }
  }

  /// 跳转到指定位置
  Future<void> seek(Duration t) {
    return _evaluateJavascript('seek(${t.inMilliseconds.toDouble() / 1000})');
  }

  /// 修改网页播放器属性
  Future<void> change({
    String? url,
    String? poster,
    Duration? position,
    PlayMode? playMode,
    double? playbackRate,
    String? aspectRatio,
    Flip? flip,
  }) async {
    final m = {};
    if (url != null && url.isNotEmpty) {
      m['url'] = url;
    }
    if (poster != null && poster.isNotEmpty) {
      m['poster'] = poster;
    }
    if (position != null) {
      m['seek'] = position.inMilliseconds.toDouble() / 1000;
    }
    if (playMode != null) {
      if (playMode == PlayMode.loop) {
        m['loop'] = true;
      } else {
        m['loop'] = false;
      }
    }
    if (playbackRate != null) {
      m['playbackRate'] = playbackRate;
    }
    if (aspectRatio != null) {
      m['aspectRatio'] = aspectRatio;
    }
    if (flip != null) {
      m['flip'] = flip.value;
    }
    return _evaluateJavascript('change(${const JsonEncoder().convert(m)})');
  }

  /// 切换全屏
  Future<void> toggleFullScreenMode() async {
    update(value.copyWith(fullscreen: !value.fullscreen));
    if (value.fullscreen) {
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);

      return AutoOrientation.landscapeAutoMode(forceSensor: true);
    } else {
      return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void toggleVerticalScreenMode() {
    update(value.copyWith(verticalScreen: !value.verticalScreen));
  }
}

class InheritedHotaruPlayer extends InheritedWidget {
  const InheritedHotaruPlayer({
    super.key,
    required this.controller,
    required super.child,
  });

  final HotaruPlayerController controller;

  @override
  bool updateShouldNotify(InheritedHotaruPlayer oldWidget) {
    return oldWidget.controller.hashCode != controller.hashCode;
  }
}
