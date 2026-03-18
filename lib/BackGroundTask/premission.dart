import 'package:permission_handler/permission_handler.dart';

void req() async {
  await Permission.notification.request();
  await Permission.ignoreBatteryOptimizations.request();


}