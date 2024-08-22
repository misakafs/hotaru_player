import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hotaru_player/src/server.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'model.dart';

class HotaruPlayerController extends WebViewController {
  final HotaruPlayerServer _server = HotaruPlayerServer();

  get server => _server;

  HotaruPlayerController({super.onPermissionRequest});

  dispose() {
    _server.close();
  }

  Future<void> postMessage(EventMessage em) {
    final msg = const JsonEncoder().convert(em);
    final script = "window.Client.postMessage('$msg')";
    return super.runJavaScript(script);
  }

  Future<void> receiveMessage(void Function(EventMessage) onMessageReceived) {
    return super.addJavaScriptChannel('Server', onMessageReceived: (msg) {
      onMessageReceived(EventMessage.fromJson(const JsonDecoder().convert(msg.message)));
    });
  }

  Future<void> listen({
    FutureOr<NavigationDecision> Function(NavigationRequest request)? onNavigationRequest,
    void Function(String url)? onPageStarted,
    void Function(String url)? onPageFinished,
    void Function(int progress)? onProgress,
    void Function(WebResourceError error)? onWebResourceError,
    void Function(UrlChange change)? onUrlChange,
    void Function(HttpAuthRequest request)? onHttpAuthRequest,
    void Function(HttpResponseError error)? onHttpError,
  }) {
    return super.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: onPageStarted,
        onPageFinished: onPageFinished,
        onProgress: onProgress,
        onWebResourceError: onWebResourceError,
        onUrlChange: onUrlChange,
        onHttpAuthRequest: onHttpAuthRequest,
        onHttpError: onHttpError,
      ),
    );
  }

  Future<void> loadFlutterAssetServer({
    Map<String, String> headers = const <String, String>{},
    Uint8List? body,
  }) async {
    super.setBackgroundColor(const Color(0x00000000));
    super.setJavaScriptMode(JavaScriptMode.unrestricted);

    if (kDebugMode) {
      super.setOnConsoleMessage((msg) {
        debugPrint('hotaru player webview console: ${msg.level}, ${msg.message}');
      });
    }

    if (super.platform is AndroidWebViewController) {
      /// 支持自动播放
      (super.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    final port = await _server.start();
    return super.loadRequest(
      Uri.parse('http://localhost:$port/assets/index.html'),
      headers: headers,
      body: body,
      method: LoadRequestMethod.get,
    );
  }
}
