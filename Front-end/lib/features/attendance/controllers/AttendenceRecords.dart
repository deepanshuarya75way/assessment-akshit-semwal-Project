import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/attendance/models/AttendenceRecords.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Attendencerecordscontroller extends GetxController {
  final Logincontroller _logincontroller = Get.put(Logincontroller());

  TextEditingController Mothcon = TextEditingController();
  final SingleValueDropDownController cnt = SingleValueDropDownController();

  int currentYear = DateTime.now().year;

  int currentMonth = DateTime.now().month;

  // ✅ Default current month & year
  int monthTypeId = DateTime.now().month;
  int yearid = DateTime.now().year;

  bool showCalender = false;

  RxBool loading = false.obs;

  DateTime selectedDate = DateTime.now();

  var attendence = <AttendanceRecord>[].obs;

  Attendencerecordsresponse attendencerecordsresponse =
      Attendencerecordsresponse();
  @override
  void onInit() {
    Mothcon.text = DateFormat('MMMM yyyy').format(DateTime.now());
    super.onInit();
    getAttendenceRecords();
  }

  Future<void> getAttendenceRecords() async {
    loading.value = true;

    try {
      int? empid = _logincontroller.box.read<int?>("UserId");

      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/AttendenceRecords';

      Map<String, dynamic> attendenceDetails = {
        'AtnMode': "M",
        'AtnYear': attendence.isEmpty ? currentYear : yearid,
        'AtnMonth': attendence.isEmpty ? currentMonth : monthTypeId,
        'authcode': _logincontroller.box.read('AppCode'),
      };

      print("Request payload: $attendenceDetails");

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(attendenceDetails),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        attendence.clear();

        attendencerecordsresponse.iserror = data["isError"];
        attendencerecordsresponse.iserrormsg = data["errorMsg"];

        final attendencelist = data["attendanceRecords"];

        for (var collection in attendencelist) {
          AttendanceRecord attendanceRecord = AttendanceRecord(
            id: collection["ID"],
            atnYear: collection["AtnYear"],
            atnMonth: collection["AtnMonth"],
            atnDate: collection["AtnDate"] != null
                ? DateTime.tryParse(collection["AtnDate"])
                : null,
            atnDay: collection["AtnDay"],
            isWeekendLeave: collection["IsWeekendLeave"],
            weekNumber: collection["WeekNumber"],
            empCode: collection["EmpCode"],
            department: collection["Department"],
            designation: collection["Designation"],
            empName: collection["EmpName"],
            empID: collection["EMPID"],
            startTime: collection["StartTime"] != null
                ? DateTime.tryParse(collection["StartTime"])
                : null,
            empShortName: collection["EmpShortName"],
            attnD: collection["AttnD"],
            sMonth: collection["SMonth"],
            atnDateDay: collection["AtnDateDay"],
            wkOrder: collection["WKOrder"],
          );

          attendence.add(attendanceRecord);
        }

        // Safe debug prints
        if (attendence.isNotEmpty) {
          print(attendence[0].atnDay);
          print(attendence.length);
        }

        print("Attendance data loaded successfully");
      } else if (response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await getAttendenceRecords(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("Failed to fetch data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }
}
