import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/attendance/models/Attendencedetails.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:http/http.dart' as http;

class Attendencedetailscontroller extends GetxController {
  final Logincontroller _logincontroller = Get.put(Logincontroller());

  TextEditingController Mothcon = TextEditingController();

  final SingleValueDropDownController cnt = SingleValueDropDownController();

  int? monthTypeId;
  int? yearid;

  bool showCalender = false;

  RxBool loading = false.obs;

  DateTime selectedDate =
      DateTime.now(); // Selected date for filtering attendance
  var attendencedetails =
      <Attendencedetails>[].obs; // Observable attendance list

  AttendenceReponse attendenceReponse =
      AttendenceReponse(); // API response model

  // Fetch attendance details from the API
  Future<void> GetAttendencedetails() async {
    showCalender = true;
    loading.value = true;
    print(loading);
    try {
      // Fetch the logged-in user ID from storage
      int? empid = _logincontroller.box.read<int?>("UserId");

      if (empid == null) {
        print("Error: User ID not found");
        return; // Stop if UserId is not available
      }

      // API endpoint
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/getAttendancedetails?empid=$empid";

      // Request payload using the selected date's year and month
      Map<String, dynamic> attendenceDetails = {
        'AtnMode': "M",
        'AtnYear': yearid,
        'AtnMonth': monthTypeId!,
      };

      print("Request payload: $attendenceDetails");

      // Send HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(attendenceDetails),
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decode JSON response

        attendencedetails.clear(); // Clear previous data

        // Parse API response fields
        attendenceReponse.iserror = data["iserror"];
        attendenceReponse.iserrormsg = data["iserrormsg"];

        if (attendenceReponse.iserror ?? true) {
          print("Error from API: ${attendenceReponse.iserrormsg}");
          return; // Stop if there's an error
        }

        // Parse attendance list if available
        final List attendenceinfo = data["empAttendencelists"] ?? [];

        for (var info in attendenceinfo) {
          Attendencedetails attendence = Attendencedetails(
            atn_year: info["atn_year"],
            atn_month: info["atn_month"],
            WEekNumber: info["WEekNumber"],
            EmpshortName: info["EmpshortName"],
            empcode: info["empcode"],
            sun_atn: info["sun_atn"],
            mon_atn: info["mon_atn"],
            tue_atn: info["tue_atn"],
            wed_atn: info["wed_atn"],
            thu_atn: info["thu_atn"],
            fri_atn: info["fri_atn"],
            sat_atn: info["sat_atn"],
          );

          attendencedetails.add(attendence); // Add to observable list
        }

        print("Attendance data loaded successfully.");
      } else {
        print("Failed to fetch data. Status: ${response.statusCode}");
      }
    } catch (ex) {
      print("Exception occurred: ${ex.toString()}");
    }
    showCalender = false;

    print(loading);
  }
}
