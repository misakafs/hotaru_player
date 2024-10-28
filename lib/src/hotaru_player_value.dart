import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HotaruPlayerValue {
  /// webview 控制器
  final InAppWebViewController? webViewController;

  /// 播放链接
  final String url;

  /// 封面
  final String poster;

  /// 是否自动播放
  final bool autoPlay;

  /// 播放器是否准备好
  final bool ready;

  /// 全屏
  final bool fullscreen;

  /// 竖屏
  final bool verticalScreen;

  /// 是否拖动
  final bool dragging;

  /// 是否正在播放
  final bool playing;

  /// 播放位置
  final Duration position;

  /// 缓冲时长
  final Duration buffered;

  /// 总时长
  final Duration duration;

  /// 时长是否超过一小时
  final bool exceedHour;

  /// 音量
  final double volume;

  /// 亮度
  final double brightness;

  /// 播放倍率
  /// 默认: 1.0
  final double playbackRate;

  /// 快进倍率，默认: 2.0
  final double speedRate;

  /// 画面比例，例子: '16:9', '4:3'
  /// 默认: ''
  final String aspectRatio;

  /// 后台播放
  /// 默认: true
  final bool backendPlayback;

  /// 播放方式：stop - 播放完暂停; loop - 循环播放; next - 播放完执行onNext函数
  /// 默认: stop
  final PlayMode playMode;

  /// 镜像翻转: normal - 正常; horizontal - 水平翻转; vertical - 上下翻转
  /// 默认: normal
  final Flip flip;

  /// 展示上部区域控件
  final bool showTopControl;

  /// 展示下部区域控件
  final bool showBottomControl;

  /// 显示音量调节提示
  final bool showVolumeToast;

  /// 显示亮度调节提示
  final bool showBrightnessToast;

  /// 显示进度调节提示
  final bool showProgressToast;

  /// 显示倍速播放提示
  final bool showSpeedToast;

  ///
  HotaruPlayerValue({
    this.webViewController,
    this.url = '',
    this.poster = '',
    this.autoPlay = true,
    this.ready = false,
    this.fullscreen = false,
    this.verticalScreen = false,
    this.dragging = false,
    this.playing = false,
    this.position = Duration.zero,
    this.buffered = Duration.zero,
    this.duration = Duration.zero,
    this.exceedHour = false,
    this.volume = 0.5,
    this.brightness = 0.5,
    this.playbackRate = 1.0,
    this.speedRate = 2.0,
    this.aspectRatio = '',
    this.backendPlayback = true,
    this.playMode = PlayMode.stop,
    this.flip = Flip.normal,
    this.showTopControl = true,
    this.showBottomControl = true,
    this.showVolumeToast = false,
    this.showBrightnessToast = false,
    this.showProgressToast = false,
    this.showSpeedToast = false,
  });

  ///
  HotaruPlayerValue copyWith({
    InAppWebViewController? webViewController,
    String? url,
    String? poster,
    bool? autoPlay,
    bool? ready,
    bool? fullscreen,
    bool? verticalScreen,
    bool? dragging,
    bool? playing,
    Duration? position,
    Duration? buffered,
    Duration? duration,
    bool? exceedHour,
    double? volume,
    double? brightness,
    double? playbackRate,
    double? speedRate,
    String? aspectRatio,
    bool? backendPlayback,
    PlayMode? playMode,
    Flip? flip,
    bool? showTopControl,
    bool? showBottomControl,
    bool? showVolumeToast,
    bool? showBrightnessToast,
    bool? showProgressToast,
    bool? showSpeedToast,
  }) {
    return HotaruPlayerValue(
      webViewController: webViewController ?? this.webViewController,
      url: url ?? this.url,
      poster: poster ?? this.poster,
      autoPlay: autoPlay ?? this.autoPlay,
      ready: ready ?? this.ready,
      fullscreen: fullscreen ?? this.fullscreen,
      verticalScreen: verticalScreen ?? this.verticalScreen,
      dragging: dragging ?? this.dragging,
      playing: playing ?? this.playing,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      duration: duration ?? this.duration,
      exceedHour: exceedHour ?? this.exceedHour,
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
      playbackRate: playbackRate ?? this.playbackRate,
      speedRate: speedRate ?? this.speedRate,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      backendPlayback: backendPlayback ?? this.backendPlayback,
      playMode: playMode ?? this.playMode,
      flip: flip ?? this.flip,
      showTopControl: showTopControl ?? this.showTopControl,
      showBottomControl: showBottomControl ?? this.showBottomControl,
      showVolumeToast: showVolumeToast ?? this.showVolumeToast,
      showBrightnessToast: showBrightnessToast ?? this.showBrightnessToast,
      showProgressToast: showProgressToast ?? this.showProgressToast,
      showSpeedToast: showSpeedToast ?? this.showSpeedToast,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'poster': poster,
      'autoPlay': autoPlay,
      'ready': ready,
      'fullscreen': fullscreen,
      'verticalScreen': verticalScreen,
      'dragging': dragging,
      'playing': playing,
      'position': position,
      'buffered': buffered,
      'duration': duration,
      'exceedHour': exceedHour,
      'volume': volume,
      'brightness': brightness,
      'playbackRate': playbackRate,
      'speedRate': speedRate,
      'aspectRatio': aspectRatio,
      'backendPlayback': backendPlayback,
      'playMode': playMode,
      'flip': flip,
      'showTopControl': showTopControl,
      'showBottomControl': showBottomControl,
      'showVolumeToast': showVolumeToast,
      'showBrightnessToast': showBrightnessToast,
      'showProgressToast': showProgressToast,
      'showSpeedToast': showSpeedToast,
    };
  }

  @override
  String toString() {
    return const JsonEncoder().convert(toJson());
  }
}

/// -------------------------------------------

/// 播放器镜像翻转
enum Flip {
  normal('normal'),
  horizontal('horizontal'),
  vertical('vertical');

  final String value;

  const Flip(this.value);
}

enum PlayMode {
  stop('stop'),
  loop('loop'),
  next('next');

  final String value;

  const PlayMode(this.value);
}
