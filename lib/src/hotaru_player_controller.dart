import 'dart:convert';
import 'dart:developer';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'hotaru_player_value.dart';

class HotaruPlayerController extends ValueNotifier<HotaruPlayerValue> {
  /// 播放地址
  /// 默认：''
  final String url;

  /// 播放封面
  /// 默认：''
  final String poster;

  /// 自动播放
  /// 默认: true
  final bool autoPlay;

  /// 后台播放
  /// 默认: true
  final bool backendPlayback;

  /// 开始播放位置
  /// 默认：0
  final Duration position;

  /// 播放方式：stop - 播放完暂停; loop - 循环播放; next - 播放完执行onNext函数
  /// 默认: stop
  final PlayMode playMode;

  /// 播放倍率
  /// 默认: 1.0
  final double playbackRate;

  /// 快进倍率
  /// 默认: 2.0
  final double speedRate;

  /// 镜像翻转: normal - 正常; horizontal - 水平翻转; vertical - 上下翻转
  /// 默认: normal
  final Flip flip;

  /// 画面比例，例子: '16:9', '4:3'
  /// 默认: ''
  final String aspectRatio;

  /// 启用混合渲染
  /// 默认: true
  final bool enableHybridComposition;

  final VoidCallback? onReady;
  final VoidCallback? onEnded;
  final VoidCallback? onNext;
  final VoidCallback? onExit;

  HotaruPlayerController({
    this.url = '',
    this.poster = '',
    this.autoPlay = true,
    this.backendPlayback = true,
    this.position = Duration.zero,
    this.playMode = PlayMode.stop,
    this.playbackRate = 1.0,
    this.speedRate = 2.0,
    this.flip = Flip.normal,
    this.aspectRatio = '',
    this.enableHybridComposition = true,
    this.onReady,
    this.onEnded,
    this.onNext,
    this.onExit,
  }) : super(
          HotaruPlayerValue(
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
      await value.webViewController?.evaluateJavascript(source: source);
      return;
    }
    log('the player is not ready');
  }

  void updateValue(HotaruPlayerValue newValue) => value = newValue;

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

    await value.webViewController?.evaluateJavascript(source: 'init($obj)');
  }

  /// 播放器播放
  Future<void> play() => _evaluateJavascript('play()');

  /// 播放器暂停
  Future<void> pause() => _evaluateJavascript('pause()');

  /// 跳转到指定位置
  Future<void> seek(Duration t) => _evaluateJavascript('seek(${t.inMilliseconds.toDouble() / 1000})');

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
    await _evaluateJavascript('change(${const JsonEncoder().convert(m)})');
  }

  Future<void> togglePlay() async {
    updateValue(value.copyWith(playing: !value.playing));
    if (value.playing) {
      await play();
    } else {
      await pause();
    }
  }

  Future<void> toggleFullScreenMode() async {
    updateValue(value.copyWith(fullscreen: !value.fullscreen));
    if (value.fullscreen) {
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);

      await AutoOrientation.landscapeAutoMode(forceSensor: true);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void toggleVerticalScreenMode() {
    updateValue(value.copyWith(verticalScreen: !value.verticalScreen));
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
