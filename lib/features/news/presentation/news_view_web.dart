import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

Widget buildNewsView({required String newsUrl, required String stationName}) {
  final viewId = 'news-iframe-$newsUrl';
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
    final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
    iframe.src = newsUrl;
    iframe.style.border = 'none';
    iframe.style.width = '100%';
    iframe.style.height = '100%';
    return iframe;
  });

  return Scaffold(
    appBar: AppBar(title: Text('$stationName Haberler')),
    body: HtmlElementView(viewType: viewId),
  );
}
