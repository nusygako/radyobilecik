import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/core/providers/player_provider.dart';
import 'package:radyo_app/core/providers/app_provider.dart';
import 'package:radyo_app/core/models/station.dart';
import 'package:radyo_app/config/constants.dart';

class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  static final List<Station> _stations = [
    Station(
      id: 'radyo11',
      name: AppConstants.radyo11Name,
      streamUrl: AppConstants.radyo11StreamUrl,
      fallbackStreamUrl: AppConstants.radyo11StreamUrlFallback,
      websiteUrl: AppConstants.radyo11Website,
      newsUrl: AppConstants.radyo11NewsUrl,
      facebookUrl: AppConstants.radyo11Facebook,
      instagramUrl: AppConstants.radyo11Instagram,
      whatsappNumber: AppConstants.radyo11WhatsApp,
      logoAssetPath: AppConstants.radyo11LogoAsset,
    ),
    Station(
      id: 'bilecikfm',
      name: AppConstants.bilecikFmName,
      streamUrl: AppConstants.bilecikFmStreamUrl,
      fallbackStreamUrl: AppConstants.bilecikFmStreamUrlFallback,
      websiteUrl: AppConstants.bilecikFmWebsite,
      newsUrl: AppConstants.bilecikFmNewsUrl,
      facebookUrl: AppConstants.bilecikFmFacebook,
      instagramUrl: AppConstants.bilecikFmInstagram,
      whatsappNumber: AppConstants.bilecikFmWhatsApp,
      logoAssetPath: AppConstants.bilecikFmLogoAsset,
    ),
  ];

  /// Extracts the display name before " - " separator.
  String _getDisplayName(String fullName) {
    final parts = fullName.split(' - ');
    return parts.first.trim();
  }

  /// Extracts frequency info after " - " separator (e.g., "FM 105.0").
  String? _getFrequency(String fullName) {
    final parts = fullName.split(' - ');
    if (parts.length > 1) return parts.last.trim();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'İstasyon Seçimi',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Dinlemek istediğiniz istasyonu seçin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 16),
            ..._stations.map((station) {
              final isSelected =
                  playerProvider.currentStation?.id == station.id;
              final primaryColor = Theme.of(context).primaryColor;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: isSelected ? 6 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: primaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await playerProvider.changeStation(station);
                      if (context.mounted) {
                        // Switch to Player tab (index 0)
                        context.read<AppProvider>().setCurrentTab(0);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Station Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.asset(
                                station.logoAssetPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : primaryColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.radio,
                                      size: 36,
                                      color: isSelected
                                          ? Colors.white
                                          : primaryColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Station Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getDisplayName(station.name),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isSelected ? primaryColor : null,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                if (_getFrequency(station.name) != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor.withOpacity(0.14)
                                          : Colors.grey.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getFrequency(station.name)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? primaryColor
                                                : Colors.grey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                if (isSelected && playerProvider.isPlaying)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.graphic_eq,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Şu An Yayında',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // Selection checkmark
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
