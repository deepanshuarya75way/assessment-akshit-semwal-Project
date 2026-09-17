import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;

import 'package:hrapp/features/leave/models/DayCalmodel.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';

class Leaverequestcontroller extends GetxController {
  final logincon = Get.put(Logincontroller());

  GetStorage box = GetStorage();

  // Controllers
  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  TextEditingController WFStatuscontroller = TextEditingController();
  TextEditingController remarkcontroller = TextEditingController();
  TextEditingController Leavesdays = TextEditingController();

  int? Leavestype;

  RxBool isloadingSummit = false.obs;

  RxBool isloading = false.obs;
  RxBool isloadingSave = false.obs;
  String? startdate;
  String? enddate;
  final SingleValueDropDownController cnt = SingleValueDropDownController();

  // Models and Variables
  DayCalresponse dayCalresponse = DayCalresponse();
  LeaverequestResponson leaverequestResponson = LeaverequestResponson();
  bool? ishalfday;
  bool? issubmit;

  // Leave Request API
  Future<void> Postleaverequest(Leaverequestmodel leaverequest) async {
    issubmit == true
        ? isloadingSummit.value = true
        : isloadingSave.value = true;

    try {
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/ADDLeavesrequest";

      Map<String, dynamic> addleave = {
        'EmpID': logincon.box.read("UserId"),
        'FromDate': startdate,
        'ToDate': enddate,
        'Remarks': remarkcontroller.text,
        'WFStatus': 'P',
        'LeaveType': Leavestype!,
        'leaveDays': Leavesdays.text,
        if (ishalfday != null) 'ishalfday': ishalfday,
        if (issubmit != null) 'issubmit': issubmit,
        'authcode': logincon.box.read('AppCode'),
      };

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      print(addleave);

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

        leaverequestResponson.iserror = data["isError"];
        leaverequestResponson.errormsg = data["errorMsg"];
        leaverequestResponson.dataadded = data["DataAdded"];
        leaverequestResponson.id = data['ID'];

        box.write('leaveId', leaverequestResponson.id);

        if (leaverequestResponson.dataadded == true) {
          print("Data successfully added.");
        } else {
          print("Something went wrong: ${leaverequestResponson.errormsg}");
        }
      } else if (response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await Postleaverequest(leaverequest); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("Failed to send request: ${response.statusCode}");
      }
    } catch (ex) {
      print("Error in Postleaverequest: $ex");
    } finally {
      issubmit == true
          ? isloadingSummit.value = false
          : isloadingSave.value = false;
    }
  }

  // Get Days Calculation API
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
        'authcode': logincon.box.read('AppCode')
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
    }

    isloading.value = false;
  }
}
