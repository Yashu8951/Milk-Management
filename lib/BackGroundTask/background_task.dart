// import 'dart:async';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:milky_management/db_helper.dart';
//
// @pragma('vm:entry-point')
// class BackgroundTask {
//
//   static Future<void> init() async {
//
//     final service = FlutterBackgroundService();
//
//     final FlutterLocalNotificationsPlugin notifications =
//     FlutterLocalNotificationsPlugin();
//
//     /// initialize notification plugin
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await notifications.initialize(settings);
//
//     /// create notification channel
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'foreground_service',
//       'Milk Background Service',
//       description: 'Background service for milk management',
//       importance: Importance.low,
//     );
//
//     await notifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//
//         notificationChannelId: 'foreground_service',
//         initialNotificationTitle: 'Milk Management',
//         initialNotificationContent: 'Background service running',
//         foregroundServiceNotificationId: 888,
//       ),
//     );
//
//     service.startService();
//   }
//
//   @pragma('vm:entry-point')
//   static void onStart(ServiceInstance service) async {
//
//     DbHelper db = DbHelper();
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'foreground_service',
//       'Foreground Service',
//       description: 'This is used for background service',
//       importance: Importance.low,
//     );
//
//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "Milk Management",
//         content: "Background running",
//       );
//     }
//
//     Timer.periodic(const Duration(hours: 4), (timer) async {
//       await db.autoFillYesterday();
//     });
//   }
// }