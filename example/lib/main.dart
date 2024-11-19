import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotaru_player/hotaru_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

const List<Video> videos = [
  Video('示例1', 'https://ik.imagekit.io/misaka/acg/202411182147001.mp4'),
  Video('示例2', 'https://hd.ijycnd.com/play/nelr0qMb/index.m3u8'),
];

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

  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = HotaruPlayerController(
      onReady: () async {
        await _initState();
      },
      onEnded: () async {
        index += 1;
        if (index >= videos.length) {
          index = 0;
        }
        final video = videos[index];
        controller.change(url: video.url);
        setState(() {});
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
    final value = prefs.getInt('position');

    Duration position = Duration.zero;

    if (value != null) {
      position = Duration(milliseconds: value);
    }

    final i = prefs.getInt('index') ?? 0;

    final video = videos[i];

    setState(() {
      index = i;
    });

    controller.init(
      url: video.url,
      position: position,
      autoPlay: true,
    );
  }

  /// 应用关闭的时候去记录一下视频播放到了哪里
  Future<void> _dispose() async {
    final prefs = await SharedPreferences.getInstance();
    final value = controller.value.position.inMilliseconds;
    await prefs.setInt('position', value);
    await prefs.setInt('index', index);
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
              child: Column(
                children: [
                  SizedBox(
                    height: height,
                    child: player,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(
                              videos[i].title,
                              style: TextStyle(color: i == index ? Theme.of(context).primaryColor : Colors.black),
                            ),
                            onTap: () {
                              final u = videos[i].url;
                              controller.change(url: u);
                              setState(() {
                                index = i;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Video {
  final String title;
  final String url;

  const Video(this.title, this.url);
}
