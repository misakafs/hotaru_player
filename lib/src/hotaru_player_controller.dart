import 'dart:convert';
import 'dart:developer';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hotaru_player/src/hotaru_player_option.dart';

import 'hotaru_player_value.dart';

class HotaruPlayerController extends ValueNotifier<HotaruPlayerValue> {
  final HotaruPlayerOption option;

  final VoidCallback? onReady;

  HotaruPlayerController({
    this.option = const HotaruPlayerOption(),
    this.onReady,
  }) : super(HotaruPlayerValue());

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
    bool? loop,
    Duration? position,
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

    if (loop != null) {
      m['loop'] = loop;
    }

    if (position != null) {
      m['seek'] = position.inMilliseconds.toDouble() / 1000;
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
    bool? loop,
    PlaybackRates? playbackRate,
    AspectRatios? aspectRatio,
    Flips? flip,
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
    if (loop != null) {
      m['loop'] = loop;
    }
    if (playbackRate != null) {
      m['playbackRate'] = playbackRate.value;
    }
    if (aspectRatio != null) {
      m['aspectRatio'] = aspectRatio.value;
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
