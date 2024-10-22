import 'package:flutter/material.dart';

import '../hotaru_player_controller.dart';

void openVideoSetting(BuildContext context, [int subSetting = 0]) {
  final controller = HotaruPlayerController.of(context);
  if (controller == null) {
    return;
  }
  if (controller.value.fullscreen) {
    openDrawer(context);
    return;
  }
  openBottomSheet(context);
}

void openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 260,
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('后台播放', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('左右反转', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('上下反转', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('上下反转', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('播放方式', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('画面尺寸', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('倍速播放', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void openDrawer(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black26,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          child: Container(
            width: 260,
            height: double.infinity,
            padding: const EdgeInsets.all(20.0),
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('后台播放', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('左右反转', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('上下反转', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('上下反转', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('播放方式', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('画面尺寸', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('倍速播放', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
