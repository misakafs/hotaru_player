import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HotaruPlayerValue {
  /// webview 控制器
  final InAppWebViewController? webViewController;

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
  final PlaybackRates playbackRate;

  /// 播放器纵横比
  final AspectRatios aspectRatio;

  /// 播放器翻转
  final Flips flip;

  /// 播放器缩放比例，默认是1
  final double playerRate;

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
    this.playbackRate = PlaybackRates.normal,
    this.aspectRatio = AspectRatios.sixteenNine,
    this.flip = Flips.normal,
    this.playerRate = 1,
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
    PlaybackRates? playbackRate,
    AspectRatios? aspectRatio,
    Flips? flip,
    double? playerRate,
    bool? showTopControl,
    bool? showBottomControl,
    bool? showVolumeToast,
    bool? showBrightnessToast,
    bool? showProgressToast,
    bool? showSpeedToast,
  }) {
    return HotaruPlayerValue(
      webViewController: webViewController ?? this.webViewController,
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
      aspectRatio: aspectRatio ?? this.aspectRatio,
      flip: flip ?? this.flip,
      playerRate: playerRate ?? this.playerRate,
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
      'aspectRatio': aspectRatio,
      'flip': flip,
      'playerRate': playerRate,
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

/// 播放倍率
enum PlaybackRates {
  half(0.5),
  normal(1.0),
  oneAndQuarter(1.25),
  oneAndHalf(1.5),
  twoTimes(2.0),
  twoAndHalf(2.5),
  triple(3.0);

  final double value;

  const PlaybackRates(this.value);
}

/// 播放器纵横比
enum AspectRatios {
  fourThree('4:3'),
  sixteenNine('16:9');

  final String value;

  const AspectRatios(this.value);
}

/// 播放器翻转
enum Flips {
  normal('normal'),
  horizontal('horizontal'),
  vertical('vertical');

  final String value;

  const Flips(this.value);
}
