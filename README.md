# Hotaru Player

- `AndroidManifest.xml`

```html

<uses-permission android:name="android.permission.INTERNET" />

<application
	...
	android:usesCleartextTraffic="true">
	...
```


```dart
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
      controller.postMessage(EventMessage('init', data: {
        'url': 'https://gcore.jsdelivr.net/gh/misakafs/hotaru_server@master/assets/test.mp4',
      }));
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
        title: Text('播放器', style: context.textTheme.titleMedium),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left_outlined,
            color: Colors.black38,
          ),
        ),
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

```