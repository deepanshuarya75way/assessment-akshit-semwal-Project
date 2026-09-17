import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> getToken(int userId) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1️⃣ Request permission (IMPORTANT)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  print("Permission status: ${settings.authorizationStatus}");

  // 2️⃣ Stop if permission denied
  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    print("Notification permission NOT granted");
    return;
  }

  // 3️⃣ Get FCM token
  String? token = await messaging.getToken();

  if (token == null) {
    print("❌ FCM token is NULL (iOS APNs issue)");
    return;
  }

  print("✅ FCM TOKEN: $token");

  // 4️⃣ Save token to DB\
  await saveTokenInDB(userId, token);

  // 5️⃣ Handle token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 Token refreshed: $newToken");
    await saveTokenInDB(userId, newToken);
  });
}

Future<void> saveTokenInDB(int userId, String token) async {
  GetStorage box = GetStorage();

  try {
    String device = checkPlatform();
    final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/save-device";

    print(url);
    Map<String, dynamic> body = {
      "UserId": userId.toString(),
      "DeviceToken": token,
      "Platform": device,
      "Authcode": box.read('AppCode')
    };

    print(body);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    // print("STATUS CODE: ${response.statusCode}");
    // print("RESPONSE BODY: ${response.body}");
    print("📡 URL: $url");
    print("📦 BODY: ${jsonEncode(body)}");
    print("📥 RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["isError"] == false) {
        print("✅ Token saved successfully");
      }
      print(response.body);
    } else {
      print("Failed: ${response.statusCode}");
      print(response.body);
    }
  } catch (ex, stacktrace) {
    print("❌ ERROR: $ex");
    print("📍 STACKTRACE: $stacktrace");
  }
}

String checkPlatform() {
  if (Platform.isAndroid) {
    print("User is on Android");

    return "Android";
  } else if (Platform.isIOS) {
    print("User is on iOS");

    return "IOS";
  } else {
    print("Unknown platform");
  }

  return "";
}

Future<void> showNotification({
  required String title,
  required String body,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'main_channel',
    'Main Notifications',
    channelDescription: 'General notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    
    details,
  );
}
