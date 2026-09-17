import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';

import 'package:hrapp/features/checkout/models/Logoutmodel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/attendance/controllers/Attendencecontroller.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final Logincontroller logincontroller = Get.put(Logincontroller());

Attendencecontroller attendencecontroller = Get.put(Attendencecontroller());

Dashboardcontroller dashboardcontroller = Get.put(Dashboardcontroller());

class Checkoutcontroller extends GetxController {
  RxBool isloading = false.obs;

  LogoutReponse logoutReponse = LogoutReponse();
  Future<void> Logout() async {
    isloading.value = true;

    String url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Signouts";
    Position currentLatLong = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    DateTime today = DateTime.now();

    // final box = GetStorage();

    DateTime currentDateTime = DateTime.now();
    int empid = logincontroller.box.read("UserId");
    final id = attendencecontroller.box.read('Id');

    String? accessToken = await Rs_hrms_config.storage.read(
      key: "accessToken",
    );

    // To display only the time in "hh:mm a" format (e.g., "08:30 PM")
    String timeOnly = DateFormat('hh:mm a').format(DateTime.now());

    print(id);
    Map<String, dynamic> attendence = {
      'empId': empid,
      'id': dashboardcontroller.getTime.AttendenceId!,
      // 'loginTime': "${DateFormat('dd MMM yyyy').format(today)} 08:00:00",
      'logoutTime': timeOnly,
      'chkinlat': "${currentLatLong.latitude}",
      'chkinlong': "${currentLatLong.longitude}",
      'authcode': logincontroller.box.read('AppCode'),
    };

    print(attendence);

    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(attendence));

    if (response.statusCode == 200) {
      final extractedData = jsonDecode(response.body);

      logoutReponse.isError = extractedData["isError"];
      logoutReponse.errorMsg = extractedData["errorMsg"];
      logoutReponse.attendancemark = extractedData["Attendancemark"];

      if (logoutReponse.attendancemark == true) {
        Get.snackbar(
          "Session",
          "Check out successfully!",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await dashboardcontroller.getdashboardDetails();
        await FlutterForegroundTask.stopService();
        dashboardcontroller.Cheackmarkatt.value = false;

        print("Service stopped");
      } else {
        print("somethingthen wrong");
      }
    } else if (response.statusCode == 401) {
      bool success = await refreshApi();

      if (success) {
        await Logout();
        return;
      } else {
        Get.offAll(() => Newloginscreen());
      }
    }
    isloading.value = false;
  }
}
