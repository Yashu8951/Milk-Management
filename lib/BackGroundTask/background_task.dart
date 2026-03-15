import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:milky_management/db_helper.dart';
@pragma('vm:entry-point')
class BackgroundTask {
 static Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: 'background_service',
        initialNotificationTitle: 'Background Service',
        initialNotificationContent: 'Service is running',
        foregroundServiceNotificationId: 888,
      ),
    );
  }
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance serviceInstance) async {
    DbHelper  db = DbHelper();
    if (serviceInstance is AndroidServiceInstance) {
      serviceInstance.setForegroundNotificationInfo(
        title: "Background Running",
        content: "Milk Management",
      );
    }
    Timer.periodic(Duration(hours: 4), (timer) async {
      await db.autoFillYesterday();
    });
  }
}
