import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/core/providers/app_provider.dart';
import 'package:radyo_app/core/providers/player_provider.dart';
import 'package:radyo_app/features/player/presentation/player_screen.dart';
import 'package:radyo_app/features/stations/presentation/stations_screen.dart';
import 'package:radyo_app/features/news/presentation/news_screen.dart';
import 'package:radyo_app/features/contact/presentation/contact_screen.dart';
import 'package:radyo_app/features/settings/presentation/settings_screen.dart';
import 'package:radyo_app/config/constants.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _appProvider = context.read<AppProvider>();
    _appProvider.onSleepTimerExpired = _handleSleepTimerExpired;
  }

  @override
  void dispose() {
    if (_appProvider.onSleepTimerExpired == _handleSleepTimerExpired) {
      _appProvider.onSleepTimerExpired = null;
    }
    super.dispose();
  }

  void _handleSleepTimerExpired() {
    if (!mounted) return;
    context.read<PlayerProvider>().pause();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Uyku zamanlayıcısı sona erdi. Yayın durduruldu.'),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildWebNewsFallback(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Haberler sekmesi web için güvenli modda açılacak',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sekmeyi açtığınızda web uyumlu haber görünümü kullanılacak.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, int currentTabIndex) {
    if (!kIsWeb) {
      return IndexedStack(
        index: currentTabIndex,
        children: const [
          PlayerScreen(),
          StationsScreen(),
          NewsScreen(),
          ContactScreen(),
          SettingsScreen(),
        ],
      );
    }

    switch (currentTabIndex) {
      case 0:
        return const PlayerScreen();
      case 1:
        return const StationsScreen();
      case 2:
        return const NewsScreen();
      case 3:
        return const ContactScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _buildWebNewsFallback(context);
    }
  }

  String _getAppBarTitle(int tabIndex, PlayerProvider playerProvider) {
    switch (tabIndex) {
      case 0:
        return playerProvider.currentStation?.name ?? AppConstants.appName;
      case 1:
        return AppConstants.stationsTab;
      case 2:
        return AppConstants.newsTab;
      case 3:
        return AppConstants.contactTab;
      case 4:
        return AppConstants.settingsTab;
      default:
        return AppConstants.appName;
    }
  }

  String _formatTimerShort(Duration? duration) {
    if (duration == null) return '0:00';
    final m = duration.inMinutes;
    final s = duration.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final playerProvider = context.watch<PlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(appProvider.currentTabIndex, playerProvider),
        ),
        actions: [
          // Sleep timer countdown chip in AppBar
          if (appProvider.isSleepTimerActive)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimerShort(appProvider.getRemainingTime()),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, appProvider.currentTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appProvider.currentTabIndex,
        onTap: appProvider.setCurrentTab,
        items: [
          // Player tab: shows green dot when playing
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.radio),
                if (playerProvider.isPlaying)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: AppConstants.playerTab,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: AppConstants.stationsTab,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: AppConstants.newsTab,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: AppConstants.contactTab,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppConstants.settingsTab,
          ),
        ],
      ),
    );
  }
}
