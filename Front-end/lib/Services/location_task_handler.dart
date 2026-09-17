import 'dart:isolate';
import 'dart:math';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/Services/Push_Notfication.dart';
import 'package:hrapp/Services/db_helper.dart';
import 'package:hrapp/Services/location_service.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';

/// 🔥 TOP LEVEL CALLBACK (MUST BE OUTSIDE CLASS)
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  @override
  DateTime? _lastSyncTime;
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("Foreground Service Started");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    try {
      // 1️⃣ Location permission check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          return;
        }
      }

      // 2️⃣ Get location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final box = GetStorage();
      int empId = box.read("UserId") ?? 0;

      if (empId == 0) {
        print("❌ Employee ID not found");
        return;
      }

      String device = await getDeviceId();

      // 3️⃣ Insert location
      await AppDatabase().insertLocation({
        "EmployeeId": empId,
        "DeviceId": device,
        "Latitude": position.latitude,
        "Longitude": position.longitude,
        "Accuracy": position.accuracy,
        "RecordedAt": DateTime.now().toIso8601String(),
        "ReceivedAt": null,
        "Source": "Background",
        "CreatedAt": DateTime.now().toIso8601String(),
        "issync": 0
      });

      // 4️⃣ Sync ONLY every 1 hour
      if (_lastSyncTime == null ||
          DateTime.now().difference(_lastSyncTime!).inHours >= 1) {
        print("🔥 1 Hour Sync Triggered");

        await AppDatabase().unsyncDataToServer();
        _lastSyncTime = DateTime.now();
      }

      // 5️⃣ Update notification
      await FlutterForegroundTask.updateService(
        notificationText: "Tracking location (sync every 1 hour)",
      );
    } catch (e, s) {
      print("❌ Location Error: $e");
      // Optional: Crashlytics
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print("Service Destroyed");
  }
}

/// 🔥 ALSO OUTSIDE CLASS
Future<void> startLocationService() async {
  await FlutterForegroundTask.startService(
    notificationTitle: 'Location Tracking Active',
    notificationText: 'Your location is being tracked every 15 min',
    callback: startCallback,
  );

  // Future<void> stopService() async {
  //   await FlutterForegroundTask.stopService();
  // }
}
