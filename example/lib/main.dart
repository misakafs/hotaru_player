import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotaru_player/hotaru_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late final HotaruPlayerController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = HotaruPlayerController(
      onReady: () async {
        await _initState();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // 应用进入后台或暂停时保存数据
      _dispose();
    }
  }

  Future<void> _initState() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('record');

    Duration position = Duration.zero;

    if (value != null) {
      position = Duration(milliseconds: value);
    }
    controller.init(
      url: 'https://v1.tlkqc.com/wjv1/202308/20/Xnh8H2jWiK2/video/index.m3u8',
      position: position,
    );
  }

  /// 应用关闭的时候去记录一下视频播放到了哪里
  Future<void> _dispose() async {
    final prefs = await SharedPreferences.getInstance();
    final value = controller.value.position.inMilliseconds;
    await prefs.setInt('record', value);
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
