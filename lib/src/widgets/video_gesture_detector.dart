import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../hotaru_player_controller.dart';

const _padding = 30.0;

class VideoGestureDetector extends StatefulWidget {
  const VideoGestureDetector({super.key});

  @override
  State<VideoGestureDetector> createState() => _VideoGestureDetectorState();
}

class _VideoGestureDetectorState extends State<VideoGestureDetector> {
  late HotaruPlayerController _controller;

  bool playing = false;

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

    var t = 5;

    if (!_controller.value.ready) {
      t = 8;
    }

    _timer = Timer(Duration(seconds: t), () {
      // 如果正在进行拖拽行为，则重新触发隐藏控件
      if (_controller.value.dragging) {
        hideControl();
        return;
      }
      if (_controller.value.playing) {
        _controller.update(
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
      _controller.update(_controller.value.copyWith(
        showTopControl: false,
        showBottomControl: false,
      ));
      return;
    }
    _controller.update(_controller.value.copyWith(
      showTopControl: true,
      showBottomControl: true,
    ));
    hideControl();
  }

  // 处理双击事件
  void _onDoubleTap() {
    if (_controller.value.playing) {
      _controller.update(_controller.value.copyWith(
        playing: false,
        showTopControl: true,
        showBottomControl: true,
      ));
      _controller.pause();
    }
  }

  // 处理长按事件
  void _onLongPressStart(LongPressStartDetails details) {
    _controller.change(
      playbackRate: _controller.value.playbackRate * 2,
    );
    _controller.update(_controller.value.copyWith(
      showSpeedToast: true,
    ));
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.change(
      playbackRate: _controller.value.playbackRate,
    );
    _controller.update(_controller.value.copyWith(
      showSpeedToast: false,
    ));
  }

  //
  void _onVerticalDragStart(DragStartDetails details) async {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth / 2) {
      // 左侧上下滑动调节屏幕亮度
      _controller.update(_controller.value.copyWith(
        showBrightnessToast: true,
      ));
    } else {
      final volume = await FlutterVolumeController.getVolume();
      // 右侧上下滑动调节音量
      _controller.update(_controller.value.copyWith(
        showVolumeToast: true,
        volume: volume,
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

    final padding = _controller.value.fullscreen ? _padding * 2 : 0;

    final delta = dragDistance / (renderBox.size.height - padding);

    if (tapPosition < screenWidth / 2) {
      // 左侧上下滑动调节屏幕亮度
      // 这里需要使用实际的亮度调节逻辑
      final brightness = (_controller.value.brightness - delta).clamp(0, 1).toDouble();
      _controller.update(_controller.value.copyWith(
        brightness: brightness,
      ));
      await ScreenBrightness.instance.setApplicationScreenBrightness(brightness);
    } else {
      // 右侧上下滑动调节音量
      // 这里需要使用实际的音量调节逻辑
      final volume = (_controller.value.volume - delta).clamp(0, 1).toDouble();
      _controller.update(_controller.value.copyWith(
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
      _controller.update(_controller.value.copyWith(
        showBrightnessToast: false,
      ));
    } else {
      // 右侧上下滑动调节音量
      _controller.update(_controller.value.copyWith(
        showVolumeToast: false,
      ));
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _controller.update(_controller.value.copyWith(
      showProgressToast: true,
    ));
    setState(() {
      playing = _controller.value.playing;

      // 如果已经播放，则暂停
      if (playing) {
        _controller.pause();
      }
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) async {
    // 屏幕左右滑动调节视频进度
    final currentPosition = _controller.value.position;

    final t = details.primaryDelta! > 0 ? currentPosition.inMilliseconds + 1000 : currentPosition.inMilliseconds - 1000;

    final position = Duration(milliseconds: t);

    _controller.update(_controller.value.copyWith(
      position: position,
    ));
    await _controller.seek(position);
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    if (playing) {
      await _controller.play();
    }
    _controller.update(_controller.value.copyWith(
      showProgressToast: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _controller.value.fullscreen ? const EdgeInsets.all(_padding) : EdgeInsets.zero,
      child: GestureDetector(
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
      ),
    );
  }
}
