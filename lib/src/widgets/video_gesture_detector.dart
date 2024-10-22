import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../hotaru_player_controller.dart';

class VideoGestureDetector extends StatefulWidget {
  const VideoGestureDetector({super.key});

  @override
  State<VideoGestureDetector> createState() => _VideoGestureDetectorState();
}

class _VideoGestureDetectorState extends State<VideoGestureDetector> {
  late HotaruPlayerController _controller;

  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = HotaruPlayerController.of(context)!;
    _controller.removeListener(listener);
    _controller.addListener(listener);
    hideControl();
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  // 隐藏控件
  void hideControl() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    if (!_controller.value.showBottomControl) {
      return;
    }

    _timer = Timer(const Duration(seconds: 5), () {
      if (_controller.value.playing) {
        _controller.updateValue(
          _controller.value.copyWith(
            showTopControl: false,
            showBottomControl: false,
          ),
        );
      }
    });
  }

  // 处理屏幕点击事件
  void _onTapUp(TapUpDetails details) {
    if (_controller.value.showTopControl && _controller.value.showBottomControl) {
      _controller.updateValue(_controller.value.copyWith(
        showTopControl: false,
        showBottomControl: false,
      ));
      return;
    }
    _controller.updateValue(_controller.value.copyWith(
      showTopControl: true,
      showBottomControl: true,
    ));
    hideControl();
  }

  // 处理双击事件
  void _onDoubleTap() {
    if (_controller.value.playing) {
      _controller.updateValue(_controller.value.copyWith(
        playing: false,
        showTopControl: true,
        showBottomControl: true,
      ));
      _controller.pause();
    }
  }

  // 处理长按事件
  void _onLongPressStart(LongPressStartDetails details) {
    _controller.updateValue(_controller.value.copyWith(
      showSpeedToast: true,
    ));
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.updateValue(_controller.value.copyWith(
      showSpeedToast: false,
    ));
  }

  //
  void _onVerticalDragStart(DragStartDetails details) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth / 2) {
      // 左侧上下滑动调节屏幕亮度
      _controller.updateValue(_controller.value.copyWith(
        showBrightnessToast: true,
      ));
    } else {
      // 右侧上下滑动调节音量
      _controller.updateValue(_controller.value.copyWith(
        showVolumeToast: true,
      ));
    }
  }

  // 处理滑动事件
  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final tapPosition = details.globalPosition.dx;
    // 滑动的垂直距离
    final dragDistance = details.delta.dy;

    if (tapPosition < screenWidth / 2) {
      // 左侧上下滑动调节屏幕亮度
      // 这里需要使用实际的亮度调节逻辑
      final brightness = (_controller.value.brightness - dragDistance / renderBox.size.height).clamp(0, 1).toDouble();
      _controller.updateValue(_controller.value.copyWith(
        brightness: brightness,
      ));
      await ScreenBrightness.instance.setApplicationScreenBrightness(brightness);
    } else {
      // 右侧上下滑动调节音量
      // 这里需要使用实际的音量调节逻辑
      final volume = (_controller.value.volume - dragDistance / renderBox.size.height).clamp(0, 1).toDouble();
      _controller.updateValue(_controller.value.copyWith(
        volume: volume,
      ));
      await FlutterVolumeController.setVolume(volume);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth / 2) {
      // 左侧上下滑动调节屏幕亮度
      _controller.updateValue(_controller.value.copyWith(
        showBrightnessToast: false,
      ));
    } else {
      // 右侧上下滑动调节音量
      _controller.updateValue(_controller.value.copyWith(
        showVolumeToast: false,
      ));
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _controller.updateValue(_controller.value.copyWith(
      showProgressToast: true,
    ));
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // 屏幕左右滑动调节视频进度
    // 这里需要实现具体的视频进度调节逻辑
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _controller.updateValue(_controller.value.copyWith(
      showProgressToast: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUp,
      onDoubleTap: _onDoubleTap,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}
