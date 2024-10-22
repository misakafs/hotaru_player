import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotaru_player/hotaru_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HotaruPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = HotaruPlayerController(
      option: const HotaruPlayerOption(
        url: 'https://vip.ffzy-video.com/20241012/3983_5e4450dc/index.m3u8',
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final height = (screenWidth * (3 / 5)).floorToDouble() - 14;

    return HotaruPlayerBuilder(
      controller: controller,
      builder: (context, player) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            // 设置状态栏背景颜色为黑色
            statusBarColor: Colors.black,
            // 确保状态栏文字为白色
            statusBarBrightness: Brightness.dark,
            // 确保状态栏图标为白色
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            body: SafeArea(
              child: SizedBox(
                height: height,
                child: player,
              ),
            ),
          ),
        );
      },
    );
  }
}
