import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildNewsView({required String newsUrl, required String stationName}) {
  return _MobileNewsView(newsUrl: newsUrl, stationName: stationName);
}

class _MobileNewsView extends StatefulWidget {
  final String newsUrl;
  final String stationName;
  const _MobileNewsView({required this.newsUrl, required this.stationName});

  @override
  State<_MobileNewsView> createState() => _MobileNewsViewState();
}

class _MobileNewsViewState extends State<_MobileNewsView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.newsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.stationName} Haberler')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
