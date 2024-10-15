import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hotaru_player/src/hotaru_player_option.dart';

import 'hotaru_player_value.dart';

class HotaruPlayerController extends ValueNotifier<HotaruPlayerValue> {
  final HotaruPlayerOption option;

  HotaruPlayerController({
    this.option = const HotaruPlayerOption(),
  }) : super(HotaruPlayerValue());

  @override
  void dispose() {
    value.webViewController?.dispose();
    super.dispose();
  }

  static HotaruPlayerController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHotaruPlayer>()?.controller;
  }

  void _evaluateJavascript(String source) {
    if (value.ready) {
      value.webViewController?.evaluateJavascript(source: source);
      return;
    }
    log('the player is not ready');
  }

  void updateValue(HotaruPlayerValue newValue) => value = newValue;

  void init({
    String? url,
    String? poster,
    bool? autoPlay = true,
    bool? loop = false,
  }) {
    final m = {
      'url': url,
      'poster': poster,
      'autoPlay': autoPlay,
      'loop': loop,
    };
    if (url == null || url.isEmpty) {
      return;
    }
    value.webViewController?.evaluateJavascript(source: 'init(${const JsonEncoder().convert(m)})');
  }

  /// 播放器播放
  void play() => _evaluateJavascript('play()');

  /// 播放器暂停
  void pause() => _evaluateJavascript('pause()');

  /// 跳转到指定位置
  void seek(Duration t) => _evaluateJavascript('seek(${t.inMilliseconds.toDouble() / 1000})');

  void change({
    String? url,
    String? poster,
    Duration? t,
    bool? loop,
  }) {
    final m = {
      'url': url,
      'poster': poster,
      'loop': loop,
    };
    if (t != null) {
      m['t'] = t.inMilliseconds.toDouble() / 1000;
    }

    _evaluateJavascript('change(${const JsonEncoder().convert(m)})');
  }

  void togglePlay() {
    updateValue(value.copyWith(playing: !value.playing));
    if (value.playing) {
      play();
    } else {
      pause();
    }
  }

  void toggleFullScreenMode() {
    updateValue(value.copyWith(fullscreen: !value.fullscreen));
    if (value.fullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
