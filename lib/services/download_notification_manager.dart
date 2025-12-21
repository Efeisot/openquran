import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadNotificationManager {
  static final DownloadNotificationManager instance =
      DownloadNotificationManager._();
  DownloadNotificationManager._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap - open app to downloads screen
      },
    );

    // Create notification channel for downloads
    const androidChannel = AndroidNotificationChannel(
      'translations_download',
      'Translation Downloads',
      description: 'Shows progress of translation downloads',
      importance: Importance.low, // Low importance to not disturb user
      playSound: false,
      enableVibration: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    // Request notification permission for Android 13+
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) return false;
    }

    // Request battery optimization exemption to prevent app from being killed
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      final status = await Permission.ignoreBatteryOptimizations.request();
      // Continue even if denied, but downloads may stop in background
    }

    return true;
  }

  Future<void> showDownloadProgress({
    required int authorId,
    required String authorName,
    required int currentSurah,
    required int totalSurahs,
  }) async {
    if (!_initialized) await initialize();

    final progress = (currentSurah / totalSurahs * 100).toInt();

    await _notifications.show(
      authorId, // Use authorId as notification ID
      'Downloading $authorName',
      'Surah $currentSurah/$totalSurahs',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'translations_download',
          'Translation Downloads',
          channelDescription: 'Shows progress of translation downloads',
          importance: Importance.low,
          priority: Priority.low,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          ongoing: true, // Can't be dismissed while downloading
          autoCancel: false,
        ),
      ),
    );
  }

  Future<void> showDownloadComplete({
    required int authorId,
    required String authorName,
  }) async {
    if (!_initialized) await initialize();

    await _notifications.show(
      authorId,
      'Download Complete',
      '$authorName has been downloaded successfully',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'translations_download',
          'Translation Downloads',
          channelDescription: 'Shows progress of translation downloads',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }

  Future<void> showDownloadError({
    required int authorId,
    required String authorName,
    required String error,
  }) async {
    if (!_initialized) await initialize();

    await _notifications.show(
      authorId,
      'Download Failed',
      '$authorName: $error',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'translations_download',
          'Translation Downloads',
          channelDescription: 'Shows progress of translation downloads',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }

  Future<void> cancelNotification(int authorId) async {
    await _notifications.cancel(authorId);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
