import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../../common/data/app_language.dart';
import '../../../../../../common/utils/constants.dart';
import '../../../../../../locator.dart';

class WebViewPage  extends StatefulWidget {
  static const String pageName = '/web-view';
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    cacheEnabled: true,
    javaScriptEnabled: true,
    useHybridComposition: true, // Better rendering
    sharedCookiesEnabled: true,
    useShouldOverrideUrlLoading: true,
    useOnLoadResource: false,
  );

  CookieManager cookieManager = CookieManager.instance();
  String? url;
  String? title;
  bool isShow = false;
  bool isSendTokenInHeader = true;
  LoadRequestMethod method = LoadRequestMethod.post;
  String token = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as List?;
      if (args != null) {
        url = args[0];
        title = args[1] ?? '';
        isSendTokenInHeader = args.length > 2 ? args[2] ?? true : true;
        method = args.length > 3 ? args[3] ?? LoadRequestMethod.post : LoadRequestMethod.post;
      }

      token = await AppData.getAccessToken();
      if (token.isNotEmpty) {
        final domain = Constants.dommain.replaceAll('https://', '');
        cookieManager.setCookie(
         url: WebUri(url!),
          name: 'XSRF-TOKEN',
          value: token,
          domain: domain,
          isHttpOnly: true,
          isSecure: true,
          path: '/',
          expiresDate: DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
        );

        cookieManager.setCookie(
         url: WebUri(url!),
          name: 'webinar_session',
          value: token,
          domain: domain,
          isHttpOnly: true,
          isSecure: true,
          path: '/',
          expiresDate: DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        );
      }

      isShow = true;
      setState(() {});
      await [Permission.camera, Permission.microphone].request();
    });
  }

  Future<void> load() async {
    final header = {
      if (isSendTokenInHeader) "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
      "x-api-key": Constants.apiKey,
      "x-locale": locator<AppLanguage>().currentLanguage.toLowerCase(),
    };

    if (!(url?.startsWith('http') ?? false)) {
      await webViewController?.loadData(data: url ?? '', baseUrl: null, historyUrl: null);
    } else {
      await webViewController?.loadUrl(
        urlRequest: URLRequest(
          method: method == LoadRequestMethod.post ? "POST" : "GET",
         url: WebUri(url ?? ''),
          headers: header,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isShow
          ? Container(
        color: Colors.white,
        height: 230,
      margin: EdgeInsets.only(left: 0),

            child: InAppWebView(
                    key: webViewKey,
                   initialSettings: settings,
                    onWebViewCreated: (controller) async {
            webViewController = controller;
            load();
                    },
                    onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
                    },
                    onProgressChanged: (controller, progress) {
            setState(() {});
                    },
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(
                    source: """
      document.body.style.margin = '0';
      document.body.style.padding = '0';
      document.documentElement.style.margin = '0';
      document.documentElement.style.padding = '0';
      
      var meta = document.createElement('meta');
      meta.name = 'viewport';
      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
      document.getElementsByTagName('head')[0].appendChild(meta);
      
      // Ensure all videos take full width
      var videos = document.getElementsByTagName('video');
      for (var i = 0; i < videos.length; i++) {
        videos[i].style.width = '100vw';   // Full width of screen
        videos[i].style.height = 'auto';   // Maintain aspect ratio
        videos[i].style.maxWidth = '100%'; // Prevent overflow
        videos[i].style.objectFit = 'cover'; // Fill container properly
      }

      // Ensure iframe (like YouTube embedded videos) take full width
      var iframes = document.getElementsByTagName('iframe');
      for (var i = 0; i < iframes.length; i++) {
        iframes[i].style.width = '100vw';
        iframes[i].style.height = '56.25vw'; // Aspect ratio 16:9
        iframes[i].style.maxWidth = '100%';
        iframes[i].style.border = 'none';
      }

      // Adjust parent containers to ensure full width
      var divs = document.getElementsByTagName('div');
      for (var i = 0; i < divs.length; i++) {
        divs[i].style.width = '100vw';
        divs[i].style.maxWidth = '100%';
        divs[i].style.overflow = 'hidden';
      }
    """,
                  );
                }


            ),
          )
          : Center(child: CircularProgressIndicator()), // Loader while loading
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    webViewController?.dispose();
    super.dispose();
  }
}
