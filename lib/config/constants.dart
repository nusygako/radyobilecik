/// Radyo App Sabitleri
class AppConstants {
  // Uygulama Bilgileri
  static const String appName = 'Radyo App';
  
  // Stream URLs
  static const String radyo11StreamUrl = 'http://radyo11.ozelip.com:9832/stream';
  static const String radyo11StreamUrlFallback = 'http://95.173.161.131:9832/stream';
  static const String bilecikFmStreamUrl = 'http://bilecikfm.kesintisizyayin.com:9980/;';
  static const String bilecikFmStreamUrlFallback =
      'http://bilecikfm.kesintisizyayin.com:9980/stream';
  
  // İstasyon Bilgileri
  static const String radyo11Name = 'Radyo 11 - FM 105.0';
  static const String radyo11Website = 'http://www.radyo11.com.tr';
  static const String radyo11NewsUrl = 'https://www.radyo11.com/haberler';
  static const String radyo11Facebook = 'https://facebook.com/radyo11';
  static const String radyo11Instagram = 'https://instagram.com/radyobilecik';
  static const String radyo11WhatsApp = '+905063111516';
  static const String radyo11LogoAsset = 'assets/logos/radyo11_logo.jpeg';
  
  static const String bilecikFmName = 'Bilecik FM - FM 99.9';
  static const String bilecikFmWebsite = 'http://www.bilecikfm.com.tr';
  static const String bilecikFmNewsUrl = 'https://www.bilecikfm.com/haberler';
  static const String bilecikFmFacebook = 'https://facebook.com/bilecikfm';
  static const String bilecikFmInstagram = 'https://instagram.com/radyobilecik';
  static const String bilecikFmWhatsApp = '+905063111516';
  static const String bilecikFmLogoAsset = 'assets/logos/bilecik_fm_logo.jpeg';
  
  // Sekme Etiketleri
  static const String playerTab = 'Canlı Yayın';
  static const String stationsTab = 'İstasyonlar';
  static const String newsTab = 'Haberler';
  static const String contactTab = 'İletişim';
  static const String settingsTab = 'Ayarlar';
  
  // Sleep Timer Seçenekleri (dakika)
  static const List<int> sleepTimerOptions = [5, 10, 15, 30, 45, 60, 90, 120];
}
