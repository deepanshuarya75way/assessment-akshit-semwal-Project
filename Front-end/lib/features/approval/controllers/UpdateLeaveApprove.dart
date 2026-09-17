import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/approval/models/UpdateLeaveApproveModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';
import 'package:http/http.dart' as http;

class Updateleaveapprove extends GetxController {
  UpdateleaveapprovemodelReponse updateleaveapprovemodelReponse =
      UpdateleaveapprovemodelReponse();

  TextEditingController commentcontroller = TextEditingController();
  Approvaldetailscontroller approvaldetailscontroller =
      Get.put(Approvaldetailscontroller());

  Future<void> postLeaveapprove(
      Updateleaveapprovemodel updateleaveapprove) async {
    try {
      final box = GetStorage();
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/LeaveApproved?authcode=${box.read('AppCode')}";

      Map<String, dynamic> LeaveApprove = {
        'Status': updateleaveapprove.Status,
        'Comment': commentcontroller.text,
        'Approval_Details_ID': updateleaveapprove.Approval_Details_ID,
        'ApprovalStatus': updateleaveapprove.ApprovalStatus,
        'recordId': updateleaveapprove.recordId,
      };

      print(LeaveApprove);

      final reponse = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(LeaveApprove),
      );

      if (reponse.statusCode == 200) {
        final data = jsonDecode(reponse.body);

        updateleaveapprovemodelReponse.isError = data["isError"];

        updateleaveapprovemodelReponse.errormsg = data["errorMsg"];
        updateleaveapprovemodelReponse.LeaveApprove = data["LeaveApprove"];

        if (updateleaveapprovemodelReponse.LeaveApprove == true) {
          print("sucesss");
          approvaldetailscontroller.GetApprovaldetails();
        } else {
          print("fail");
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
