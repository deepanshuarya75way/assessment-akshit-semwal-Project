import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;

class RS_HRMS_LOG extends GetxController {
  GetStorage box = GetStorage();

  Future<void> createlogs(String message) async {
    Map<String, dynamic> body = {
      "userid": box.read("UserId"),
      "DeviceInfo": "Andriod",
      "logMsg": message,
      "Authcode": box.read("AppCode"),
    };
    try {
      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/RsHRMSLOG";

      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);
      }
    } catch (e) {}
  }
}
