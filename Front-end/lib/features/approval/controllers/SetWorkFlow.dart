import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/approval/models/SetworkFlow.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';
import 'package:hrapp/view/navbar.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

class Setworkflow extends GetxController {
  SetworkResponse setworkResponse = SetworkResponse();

  // Approvaldetailscontroller approvaldetailscontroller =
  //     Get.put(Approvaldetailscontroller());

  Dashboardcontroller dashboardcontroller = Get.put(Dashboardcontroller());

  TextEditingController Comment = TextEditingController();
  SetworkflowApprover setworkflowApprover = SetworkflowApprover();
  Future<void> SetWorkFlow(
    int workflow,
    int approvalDetailId,
    int recordId,
    String action,
  ) async {
    final box = GetStorage();

    Map<String, dynamic> workFlow = {
      "ApprovalDetailId": approvalDetailId,
      "Workflow": workflow,
      "RecordId": recordId,
      "Action": action,
      "Comment": Comment.text.trim().isEmpty ? "" : Comment.text.trim()
    };

    try {
      final code = box.read('AppCode');
      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Setworkflow?authcode=$code';

      print("Request Body: $workFlow");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(workFlow),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setworkResponse.isError = data["isError"] ?? true;
        setworkResponse.errorMsg = data["errorMsg"] ?? "";
        setworkResponse.result = data["result"];

        if (setworkResponse.isError == false) {
          print("Workflow Set Successfully ✅");

          await dashboardcontroller.getdashboardDetails();
        } else {
          print("API Error: ${setworkResponse.errorMsg}");
        }
      } else {
        print("API Failed: ${response.statusCode}");
      }
    } catch (ex) {
      print("Exception: $ex");
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
