import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/core/providers/player_provider.dart';

import 'news_view_stub.dart'
    if (dart.library.html) 'news_view_web.dart'
    if (dart.library.io) 'news_view_mobile.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        final station = playerProvider.currentStation;
        final newsUrl = station?.newsUrl ?? '';

        if (newsUrl.isEmpty || !newsUrl.startsWith('http')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Haber URL\'si yapılandırılmamış',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lütfen bir istasyon seçin ve\nhaber URL\'sini yapılandırın',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return buildNewsView(newsUrl: newsUrl, stationName: station?.name ?? '');
      },
    );
  }
}
