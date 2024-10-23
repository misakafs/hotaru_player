import 'package:flutter/material.dart';
import 'package:hotaru_player/src/hotaru_player_controller.dart';
import 'package:hotaru_player/src/player.dart';
import 'package:hotaru_player/src/widgets/brightness_toast.dart';
import 'package:hotaru_player/src/widgets/progress_toast.dart';
import 'package:hotaru_player/src/widgets/speed_toast.dart';
import 'package:hotaru_player/src/widgets/video_bottom_bar.dart';
import 'package:hotaru_player/src/widgets/video_gesture_detector.dart';
import 'package:hotaru_player/src/widgets/video_top_bar.dart';
import 'package:hotaru_player/src/widgets/volume_toast.dart';

class HotaruPlayer extends StatefulWidget {
  final HotaruPlayerController controller;

  const HotaruPlayer({
    super.key,
    required this.controller,
  });

  @override
  State<HotaruPlayer> createState() => _HotaruPlayerState();
}

class _HotaruPlayerState extends State<HotaruPlayer> {
  late HotaruPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didUpdateWidget(HotaruPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InheritedHotaruPlayer(
        controller: controller,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // 播放器
            Center(
              child: SizedBox(
                width: controller.value.fullscreen ? MediaQuery.sizeOf(context).width : null,
                child: Player(
                  key: widget.key,
                ),
              ),
            ),
            // 手势检测:
            // 单击：展示控件，3秒后自动隐藏控件，再次单击隐藏控件
            // 双击: 暂停播放，显示控件，再次单击播放，并3秒后隐藏控件
            // 长按：加速播放
            // 左侧上下滑动: 调节屏幕亮度
            // 右侧上下滑动: 调节音量大小
            // 左右滑动：调节播放进度
            const VideoGestureDetector(),
            // 顶部控件:
            // 左侧：
            //   返回
            //   返回首页
            // 右侧:
            //   菜单
            const VideoTopBar(),
            // 底部控件:
            // 左侧:
            //   播放暂停
            // 中间:
            //   进度条
            // 右侧:
            //   全屏/小屏
            const VideoBottomBar(),
            // 音量调节提示框
            const VolumeToast(),
            // 亮度调节提示框
            const BrightnessToast(),
            // 进度调节提示框
            const ProgressToast(),
            // 倍速播放提示框
            const SpeedToast(),
          ],
        ),
      ),
    );
  }
}
