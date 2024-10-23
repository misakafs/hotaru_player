import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';
import '../hotaru_player_value.dart';
import 'setting_tile.dart';

/// 设置按钮
class SettingButton extends StatefulWidget {
  const SettingButton({
    super.key,
  });

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  late HotaruPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = HotaruPlayerController.of(context)!;
    _controller.removeListener(listener);
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  void openVideoSetting(BuildContext context) {
    _controller.updateValue(_controller.value.copyWith(
      showTopControl: false,
      showBottomControl: false,
    ));
    final settingTiles = _buildSettingTiles();
    if (_controller.value.fullscreen) {
      openDrawer(context, settingTiles);
      return;
    }
    openBottomSheet(context, settingTiles);
  }

  Widget _buildSettingTiles() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            SettingTile(
              title: '后台播放',
              options: const [
                Option('启用', true),
                Option('关闭', false),
              ],
              selected: _controller.value.backendPlayback,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  backendPlayback: option.v as bool,
                ));
              },
            ),
            SettingTile(
              title: '镜像反转',
              options: const [
                Option('正常', Flip.normal),
                Option('水平翻转', Flip.horizontal),
                Option('上下翻转', Flip.vertical),
              ],
              selected: _controller.value.flip,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  flip: option.v as Flip,
                ));
                _controller.change(flip: option.v);
              },
            ),
            SettingTile(
              title: '播放方式',
              options: const [
                Option('播完暂停', PlayMode.stop),
                Option('单集循环', PlayMode.loop),
                Option('自动连播', PlayMode.next),
              ],
              selected: _controller.value.playMode,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  playMode: option.v as PlayMode,
                ));
                _controller.change(playMode: option.v);
              },
            ),
            SettingTile(
              title: '画面尺寸',
              options: const [
                Option('自适应', ''),
                Option('19:6', '19:6'),
                Option('4:3', '4:3'),
              ],
              selected: _controller.value.aspectRatio,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  aspectRatio: option.v as String,
                ));
                _controller.change(aspectRatio: option.v);
              },
            ),
            SettingTile(
              title: '播放倍率',
              options: const [
                Option('0.5', 0.5),
                Option('1.0', 1.0),
                Option('1.25', 1.25),
                Option('1.5', 1.5),
                Option('2.0', 2.0),
                Option('2.5', 2.5),
                Option('3.0', 3.0),
              ],
              selected: _controller.value.playbackRate,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  playbackRate: option.v as double,
                ));
                _controller.change(playbackRate: option.v);
              },
            ),
            SettingTile(
              title: '快进倍率',
              options: const [
                Option('2.0', 2.0),
                Option('3.0', 3.0),
                Option('4.0', 4.0),
                Option('5.0', 5.0),
              ],
              selected: _controller.value.speedRate,
              onSelected: (option) {
                _controller.updateValue(_controller.value.copyWith(
                  speedRate: option.v as double,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void openBottomSheet(BuildContext context, Widget settingTiles) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (BuildContext buildContext) {
        return Container(
          height: 320,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: SingleChildScrollView(
              child: settingTiles,
            ),
          ),
        );
      },
    );
  }

  void openDrawer(BuildContext context, Widget settingTiles) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              height: double.infinity,
              padding: const EdgeInsets.all(20.0),
              color: Colors.black.withOpacity(0.8),
              child: SingleChildScrollView(
                child: settingTiles,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
      ),
      onPressed: () {
        openVideoSetting(context);
      },
    );
  }
}
