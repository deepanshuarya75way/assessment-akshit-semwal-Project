import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/attendance/models/AttendenceModel.dart';
import 'package:hrapp/features/attendance/models/Attendencedetails.dart';
import 'package:hrapp/features/checkout/models/Logoutmodel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Services/location_task_handler.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/core/utils/RS_HRMS_LOG.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

final Logincontroller logincontroller = Get.put(Logincontroller());

class Attendencecontroller extends GetxController {
  bool mark = true;
  final box = GetStorage();

  Dashboardcontroller dashboardcontroller = Get.put(Dashboardcontroller());

  RS_HRMS_LOG rs_hrms_log = Get.put(RS_HRMS_LOG());

  LogoutReponse logoutReponse = LogoutReponse();
  AttendenceRes attendenceReponse = AttendenceRes();

  RxBool loading = false.obs;

  Future<void> GetMarkAttendence() async {
    final RoleController roleController = Get.find<RoleController>();
    loading.value = true;
    DateTime today = DateTime.now();

    String? lastMarkedDateStr = box.read('lastMarkedDate');
    if (lastMarkedDateStr == null ||
        DateTime.parse(lastMarkedDateStr).day != today.day) {
      mark = true;
    }

    if (mark) {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await Geolocator.requestPermission();
          throw Exception("Location permission required");
        }

        Position currentLatLong = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        String? accessToken = await Rs_hrms_config.storage.read(
          key: "accessToken",
        );

        int empid = logincontroller.box.read("UserId");
        String url =
            "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Attendance";

        // Use ISO datetime format (SQL-friendly)
        final loginDateTime =
            DateTime(today.year, today.month, today.day, 8, 0);
        final logoutDateTime =
            DateTime(today.year, today.month, today.day, 16, 0);

        final loginTime = loginDateTime.toIso8601String();
        final logoutTime = logoutDateTime.toIso8601String();

        print("Sending loginTime: $loginTime");
        print("Sending logoutTime: $logoutTime");
        DateTime now = DateTime.now();
        String sqlDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
        print(now);

        Map<String, dynamic> attendence = {
          'empId': empid,
          'loginTime': sqlDateTime,
          'logoutTime': logoutTime,
          'chkinlat': "${currentLatLong.latitude}",
          'chkinlong': "${currentLatLong.longitude}",
          'authcode': logincontroller.box.read('AppCode')
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

          attendenceReponse.id = extractedData["attid"];
          attendenceReponse.errorMsg = extractedData["errorMsg"];
          RegExp regExp = RegExp(r"AttendanceID:\s*(\d+)");
          Match? match = regExp.firstMatch(attendenceReponse.id!);

          String attendanceId = match?.group(1) ?? "";

          print("Attendance ID: $attendanceId");
          if (attendenceReponse.errorMsg == null) {
            box.write("Id", attendenceReponse.id);
          }

          box.write('lastMarkedDate', today.toIso8601String());
          mark = false;

          dashboardcontroller.Cheackmarkatt.value = true;

          // Get.snackbar("Attendance", "Attendance marked successfully!",
          //     snackPosition: SnackPosition.top,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          // await startLocationService();

          print("success");
          print(attendence);

          await roleController.getUserRole();

          if (roleController.enableLocationTracking.value == true) {
            await startLocationService();
          }

          print(roleController.enableLocationTracking.value);

          await dashboardcontroller.getdashboardDetails();
        } else if (response.statusCode == 401) {
          //  refresh api call
          bool success = await refreshApi();

          if (success) {
            await GetMarkAttendence(); // Retry API
            return;
          } else {
            // Refresh token expired
            await Rs_hrms_config.storage.deleteAll();
            Get.offAll(() => Newloginscreen());
          }
        } else {}
        loading.value = false;
      } catch (ex, s) {
        FirebaseCrashlytics.instance.recordError(ex, s);

        rs_hrms_log.createlogs("Reason: ${ex.toString()}\n"
            "StackTrace: ${s.toString()}");
        print("Error: ${ex.toString()}");
        loading.value = false;
      }
    } else {
      // Get.snackbar("Attendance", "Already marked attendance!",
      //     snackPosition: SnackPosition.top,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      loading.value = false;
    }
  }

  Future<void> Logout() async {
    String url =
        "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Signouts?authcode=${logincontroller.box.read('AppCode')}";
    Position currentLatLong = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    DateTime today = DateTime.now();

    int empid = logincontroller.box.read("UserId");
    int? id = box.read('Id');

    Map<String, dynamic> attendence = {
      'empId': empid,
      'id': id,
      'logoutTime': today.toIso8601String(),
      'chkinlat': "${currentLatLong.latitude}",
      'chkinlong': "${currentLatLong.longitude}",
    };

    print(attendence);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(attendence));

    if (response.statusCode == 200) {
      final extractedData = jsonDecode(response.body);

      logoutReponse.isError = extractedData["isError"];
      logoutReponse.errorMsg = extractedData["errorMsg"];
      logoutReponse.attendancemark = extractedData["Attendancemark"];

      if (logoutReponse.attendancemark == true) {
        Get.snackbar(
          "Session",
          "Logged out successfully!",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Something went wrong");
      }
    }
  }
}
