import 'package:flutter/material.dart';
import 'package:hotaru_player/hotaru_player.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late HotaruPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = HotaruPlayerController();
    controller.loadFlutterAssetServer();
    controller.listen(onPageFinished: (url) async {
      controller.postMessage(EventMessage.init({
        'url': 'https://gcore.jsdelivr.net/gh/misakafs/hotaru_server@master/assets/test.mp4',
      }));
    });
    controller.receiveMessage((evt) {
      print("接收消息: ${evt.event}, ${evt.data}");
    });
  }

  @override
  void dispose() {
    controller.server.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final height = (screenWidth * (3 / 5)).floorToDouble() - 14;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('播放器'),
      ),
      body: Container(
        width: double.infinity,
        height: height,
        color: Colors.black,
        child: HotaruPlayerWidget(
          controller: controller,
        ),
      ),
    );
  }
}
