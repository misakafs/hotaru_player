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
