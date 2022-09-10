import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchpageWebview extends StatelessWidget {
  final String? initialUrl;
  final Function addHistoryFunction;
  final Function(double) loading;
  final Function(String) currentUrl;
  final Completer<WebViewController> controller;

  const SearchpageWebview({
    Key? key,
    required this.initialUrl,
    required this.loading,
    required this.controller,
    required this.currentUrl,
    required this.addHistoryFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: initialUrl,
      onWebViewCreated: (webviewController) =>
          controller.complete(webviewController),
      onPageStarted: (url) {
        loading(0);
        currentUrl(url);
        addHistoryFunction();
      },
      onProgress: (v) => loading(v / 100),
      onPageFinished: (url) => loading(1),
      // onWebResourceError: ,
      javascriptMode: JavascriptMode.unrestricted,
      // zoomEnabled: false,
      // allowsInlineMediaPlayback: true,
    );
  }
}
