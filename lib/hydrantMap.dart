import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HydrantMap extends StatelessWidget {
  HydrantMap({Key? key}) : super(key: key);
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "https://wasserkarte.info/watermap/waterSources/view?all=1&tpl=map",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController){
        _controller.complete(webViewController);
      }
    );
  }
}
