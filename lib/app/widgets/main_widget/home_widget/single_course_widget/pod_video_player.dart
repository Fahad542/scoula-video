import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:webview_flutter/webview_flutter.dart';

//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;

  const PodVideoPlayerDev(this.url, this.type, {super.key});

  @override
  State<PodVideoPlayerDev> createState() => _PodVideoPlayerDevState();
}

class _PodVideoPlayerDevState extends State<PodVideoPlayerDev> {
  late PodPlayerController controller;

  @override
  void initState() {
    super.initState();

    if (widget.type == 'vimeo') {
      // ✅ Vimeo: Try Direct MP4 URL if available
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(widget.url),
        podPlayerConfig: const PodPlayerConfig(autoPlay: true),
      );
    } else if (widget.type == 'youtube') {
      // ✅ YouTube Video Player
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(widget.url),
        podPlayerConfig: const PodPlayerConfig(autoPlay: true),
      );
    } else {
      // ✅ Direct MP4 URL
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(widget.url),
        podPlayerConfig: const PodPlayerConfig(autoPlay: true),
      );
    }

    controller.initialise();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PodVideoPlayer(controller: controller),
        ),
      ),
    );
  }
}








class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  String? embedUrl;

  @override
  void initState() {
    super.initState();
    String? videoId = extractVideoId(widget.videoUrl);

    if (videoId != null) {
      embedUrl =
      "https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&rel=0";
    }
  }

  String? extractVideoId(String url) {
    Uri uri = Uri.parse(url);

    if (uri.host.contains("youtube.com")) {
      return uri.queryParameters['v'];
    }

    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (embedUrl == null) {
      return Center(child: Text("Invalid video URL"));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Border radius applied
      child: AspectRatio(
        aspectRatio: 16 / 9, // Maintain correct video aspect ratio
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(embedUrl!)),
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
            ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
          ),
        ),
      ),
    );
  }
}



// class YoutubeWebView extends StatefulWidget {
//   @override
//   _YoutubeWebViewState createState() => _YoutubeWebViewState();
// }
//
// class _YoutubeWebViewState extends State<YoutubeWebView> {
//   late WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the WebView controller
//     WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Video'),
//       ),
//       body: WebView(
//         initialUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Replace with your video URL
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller = webViewController;
//         },
//       ),
//     );
//   }
// }




