import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:radyo_app/app.dart';
import 'package:radyo_app/core/providers/app_provider.dart';
import 'package:radyo_app/core/providers/player_provider.dart';
import 'package:radyo_app/core/services/audio_handler.dart';
import 'package:radyo_app/core/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBAUvMEE0m3mZMrSDSoJg8-x-Jq7_Qh_wk',
          appId: '1:157353950176:android:8c8ccf0a11d45fb8684985',
          messagingSenderId: '157353950176',
          projectId: 'radyobilecik',
          storageBucket: 'radyobilecik.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Initialize Notification Service
  final notificationService = NotificationService();
  try {
    await notificationService.initialize();
  } catch (e) {
    debugPrint('Notification init error: $e');
  }

  // Audio handler (simple just_audio)
  final audioHandler = RadioAudioHandler();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider(audioHandler)),
      ],
      child: const RadyoApp(),
    ),
  );
}
