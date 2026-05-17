import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/core/providers/player_provider.dart';
import 'package:radyo_app/core/models/station.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String _getStatusLabel(PlayerProvider p) {
    if (p.hasError) return 'Bağlantı Hatası';
    if (p.isLoading) return 'Bağlanıyor...';
    if (p.isPlaying) return 'Şu An Çalıyor';
    if (p.isConnected) return 'Duraklatıldı';
    return 'Hazır';
  }

  Color _getStatusColor(PlayerProvider p, BuildContext context) {
    if (p.hasError) return Colors.red;
    if (p.isPlaying) return Colors.green;
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        final station = playerProvider.currentStation;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [
                      Color(0xFF0D1117),
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                    ]
                  : const [
                      Color(0xFFE3F2FD),
                      Color(0xFFBBDEFB),
                      Color(0xFFFFFFFF),
                    ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Station Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: station == null
                                ? _buildFallbackIcon(context)
                                : Image.asset(
                                    station.logoAssetPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildFallbackIcon(context),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Station Name
                        Text(
                          station?.name ?? 'İstasyon Seçiniz',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(playerProvider, context)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (playerProvider.isPlaying)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Text(
                                _getStatusLabel(playerProvider),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(playerProvider, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Song title
                        Text(
                          playerProvider.songTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        if (playerProvider.artistName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            playerProvider.artistName,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Error banner
                if (playerProvider.hasError) ...[
                  Card(
                    color: isDark
                        ? const Color(0xFF2D1B1B)
                        : const Color(0xFFFFEBEE),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              playerProvider.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: playerProvider.reconnect,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Yeniden Bağlan'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Play Controls Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_previous, size: 36),
                            ),
                            const SizedBox(width: 24),

                            // Main Play/Pause button with gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: playerProvider.hasError
                                      ? [Colors.red, Colors.redAccent]
                                      : [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.75),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (playerProvider.hasError
                                            ? Colors.red
                                            : Theme.of(context).primaryColor)
                                        .withOpacity(0.4),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: playerProvider.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(22),
                                      child: SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      iconSize: 48,
                                      icon: Icon(
                                        playerProvider.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (!playerProvider.isStreamUrlValid) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Yayın adresi henüz yapılandırılmamış',
                                              ),
                                              duration: Duration(seconds: 3),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          return;
                                        }
                                        playerProvider.togglePlayPause();
                                      },
                                    ),
                            ),

                            const SizedBox(width: 24),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_next, size: 36),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Volume Control
                        Row(
                          children: [
                            const Icon(Icons.volume_down),
                            Expanded(
                              child: Slider(
                                value: playerProvider.volume,
                                onChanged: playerProvider.setVolume,
                                min: 0.0,
                                max: 1.0,
                              ),
                            ),
                            const Icon(Icons.volume_up),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Social Media Links
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sosyal Medya',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _SocialButton(
                              icon: Icons.facebook,
                              label: 'Facebook',
                              color: const Color(0xFF1877F2),
                              onTap: () =>
                                  _launchUrl(station?.facebookUrl ?? ''),
                            ),
                            _SocialButton(
                              icon: Icons.camera_alt,
                              label: 'Instagram',
                              color: const Color(0xFFE4405F),
                              onTap: () =>
                                  _launchUrl(station?.instagramUrl ?? ''),
                            ),
                            _SocialButton(
                              icon: Icons.language,
                              label: 'Website',
                              color: Colors.teal,
                              onTap: () =>
                                  _launchUrl(station?.websiteUrl ?? ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.7),
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.radio, size: 64, color: Colors.white),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
