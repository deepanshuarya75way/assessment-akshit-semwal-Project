import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart' as logincon;
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;
import 'package:hrapp/features/leave/models/DayCalmodel.dart';
import 'package:hrapp/features/leave/models/Leaveupdatedmodel.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';

class Updatedleavecontroller extends GetxController {
  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  TextEditingController WFStatuscontroller = TextEditingController();
  TextEditingController remarkcontroller = TextEditingController();
  TextEditingController Leavesdays = TextEditingController();
  bool? ishalfday = false;
  bool? issubmit = true;
  final SingleValueDropDownController cnt =
      SingleValueDropDownController(); // Use this
  LeaveUpdatedResponse leaveUpdatedResponse = LeaveUpdatedResponse();
  DayCalresponse dayCalresponse = DayCalresponse();
  int? selectedLeaveType;
  int? Leavestype; // Note: This seems unused; consider removing if not needed
  String? startdate;
  String? enddate;
  RxBool isloading = false.obs;

  final logincontrol = Get.put(Logincontroller());

  RxBool isloadingSummit = false.obs;

  RxBool isloadingSave = false.obs;

  Future<void> Updatedleave(int? newleaveid) async {
    try {
      issubmit == true
          ? isloadingSummit.value = true
          : isloadingSave.value = true;
      isloading.value = true;
      int? empId = logincontrol.box.read("UserId");
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/LeaveUpdated?id=$newleaveid";

      Map<String, dynamic> addleave = {
        'EmpID': empId,
        'FromDate': ishalfday == true ? todatecontroller.text : startdate,
        'ToDate': enddate,
        'Remarks': remarkcontroller.text,
        'WFStatus': 'P',
        'LeaveType': ishalfday == true ? 1 : selectedLeaveType,
        'leaveDays': Leavesdays.text,
        if (ishalfday != null) 'ishalfday': ishalfday,
        if (issubmit != null) 'isSubmit': issubmit,
        'authcode': logincontrol.box.read('AppCode'),
      };

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      print("Payload: $addleave");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(addleave),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        leaveUpdatedResponse.isError = data["isError"];
        leaveUpdatedResponse.errorMsg = data["errorMsg"];
        leaveUpdatedResponse.updatedscucessfully = data["updatedscucessfully"];
      } else if (response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await Updatedleave(newleaveid); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        throw Exception(
            "API request failed with status: ${response.statusCode}");
      }
    } catch (ex) {
      print("Error updating leave: $ex");
      throw ex;
    } finally {
      isloading.value = false;
      isloadingSummit.value = false;
      isloadingSave.value = false;
    }
  }

  Future<void> Getdayscal() async {
    isloading.value = true;
    try {
      String url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Dayscal";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      Map<String, dynamic> dayscal = {
        'FromDate': startdate,
        'ToDate': enddate,
        'authcode': logincon.box.read('AppCode'),
      };

      print(dayscal);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(dayscal),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        dayCalresponse.iserror = data["isError"];
        dayCalresponse.errormasg = data["errorMsg"];
        dayCalresponse.dayscalculate = data["Dayscalculate"];

        Leavesdays.text = dayCalresponse.dayscalculate.toString();

        print(Leavesdays.text);
        print("Days calculated: ${dayCalresponse.dayscalculate}");
      } else if (response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await Getdayscal(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("Failed to get days: ${response.statusCode}");
      }
    } catch (ex) {
      print("Error in Getdayscal: $ex");
    } finally {
      isloading.value = false;
    }
  }

  @override
  void onClose() {
    fromdatecontroller.dispose();
    todatecontroller.dispose();
    WFStatuscontroller.dispose();
    remarkcontroller.dispose();
    Leavesdays.dispose();
    cnt.dispose();
    super.onClose();
  }
}
