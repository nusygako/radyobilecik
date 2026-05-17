class Station {
  final String id;
  final String name;
  final String streamUrl;
  final String fallbackStreamUrl;
  final String websiteUrl;
  final String newsUrl;
  final String facebookUrl;
  final String instagramUrl;
  final String whatsappNumber;
  final String logoAssetPath;

  const Station({
    required this.id,
    required this.name,
    required this.streamUrl,
    required this.fallbackStreamUrl,
    required this.websiteUrl,
    required this.newsUrl,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.whatsappNumber,
    required this.logoAssetPath,
  });

  Station copyWith({
    String? id,
    String? name,
    String? streamUrl,
    String? fallbackStreamUrl,
    String? websiteUrl,
    String? newsUrl,
    String? facebookUrl,
    String? instagramUrl,
    String? whatsappNumber,
    String? logoAssetPath,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      fallbackStreamUrl: fallbackStreamUrl ?? this.fallbackStreamUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      newsUrl: newsUrl ?? this.newsUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      logoAssetPath: logoAssetPath ?? this.logoAssetPath,
    );
  }
}
