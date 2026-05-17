import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/core/providers/app_provider.dart';
import 'package:radyo_app/config/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Text(
              'Ayarlar',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Theme Settings
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Tema'),
                    subtitle: Text(_getThemeModeLabel(appProvider.themeMode)),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Açık'),
                          icon: Icon(Icons.light_mode, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Koyu'),
                          icon: Icon(Icons.dark_mode, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('Sistem'),
                          icon: Icon(Icons.auto_mode, size: 16),
                        ),
                      ],
                      selected: {appProvider.themeMode},
                      onSelectionChanged: (Set<ThemeMode> selection) {
                        appProvider.setThemeMode(selection.first);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sleep Timer
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Uyku Zamanlayıcı'),
                    subtitle: appProvider.isSleepTimerActive
                        ? Text(
                            _formatRemainingTime(
                                appProvider.getRemainingTime()),
                          )
                        : const Text('Kapalı'),
                    trailing: appProvider.isSleepTimerActive
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: appProvider.cancelSleepTimer,
                            tooltip: 'İptal Et',
                          )
                        : null,
                  ),

                  // Countdown progress bar
                  if (appProvider.isSleepTimerActive) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: appProvider.getRemainingProgress(),
                          minHeight: 6,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.15),
                        ),
                      ),
                    ),
                  ],

                  if (!appProvider.isSleepTimerActive) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Süre Seçin (dakika)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                AppConstants.sleepTimerOptions.map((minutes) {
                              return ActionChip(
                                label: Text('$minutes dk'),
                                onPressed: () {
                                  appProvider.setSleepTimer(minutes);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Uyku zamanlayıcı $minutes dakikaya ayarlandı',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notification Settings
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Bildirimler'),
                    subtitle: const Text('Anlık bildirim ayarları'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bildirim ayarları (yakında)'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // About
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Hakkında'),
                    subtitle: Text('Radyo App v1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('Uygulama Bilgisi'),
                    subtitle: const Text('Flutter ile geliştirilmiştir'),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.radio, size: 48),
                        children: const [
                          Text(
                            'Radyo 11 ve Bilecik FM için canlı radyo yayın uygulaması',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Açık tema';
      case ThemeMode.dark:
        return 'Koyu tema';
      case ThemeMode.system:
        return 'Sistem teması';
    }
  }

  String _formatRemainingTime(Duration? duration) {
    if (duration == null) return 'Kapalı';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')} kaldı';
    } else {
      return '$seconds saniye kaldı';
    }
  }
}
