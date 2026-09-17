import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> sendLocation(List<Map<String, dynamic>> dbData) async {
  final box = GetStorage();
  final authCode = box.read('AppCode');

  if (authCode == null || authCode.toString().isEmpty) {
    print("❌ AppCode missing");
    return false;
  }

  // 🔁 Transform DB data → API payload
  final payload = dbData.map((e) {
    return {
      "employeeId": e["EmployeeId"],
      "deviceId": e["DeviceId"],
      "latitude": e["Latitude"],
      "longitude": e["Longitude"],
      "accuracy": e["Accuracy"],
      "recordedAt": e["RecordedAt"],
      "source": e["Source"],
    };
  }).toList();

  try {
    final url =
        "https://rs-apps.online/Rsatsapi/api/fixATS/GetLoction?authcode=$authCode";

    print("🚀 Sending ${payload.length} locations");
    print("📦 Payload: ${jsonEncode(payload)}");

    final res = await http
        .post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(payload), // ✅ RAW ARRAY
        )
        .timeout(const Duration(seconds: 20));

    print("📡 Status: ${res.statusCode}");
    print("📡 Response: ${res.body}");

    return res.statusCode == 200;
  } catch (e) {
    print("❌ API Error: $e");
    return false;
  }
}

String getDeviceId() {
  if (Platform.isAndroid) {
    return "ANDROID";
  }

  if (Platform.isIOS) {
    return "IOS";
  }

  return "unknown_device";
}
// Future<void> initDeviceId() async {
//   final deviceId = await getDeviceId();

//   final box = GetStorage();
//   box.write("DeviceId", deviceId);

//   print("DeviceId Stored: $deviceId");
// }
