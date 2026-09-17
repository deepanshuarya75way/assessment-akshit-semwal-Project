import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hrapp/features/leave/models/Halfdaylistmodel.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';

import 'package:http/http.dart' as http;

class Halfdayleavecontroller extends GetxController {
  final logincon = Get.put(Logincontroller());

  Allleavecontroller allleave = Get.put(Allleavecontroller());
  TextEditingController fromdatecontroller = TextEditingController();

  TextEditingController WFStatuscontroller = TextEditingController();

  bool? ishalfday;
  bool? issubmit;
  // TextEditingController issubmit = TextEditingController();

  // TextEditingController dropdowncontroller = TextEditingController();

  final SingleValueDropDownController cnt = SingleValueDropDownController();

  TextEditingController remarkcontroller = TextEditingController();

  LeaverequestResponson leaverequestResponson = LeaverequestResponson();

  Future<void> Postleaverequest(Halfdaylistmodel halfday) async {
    try {
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/ADDLeavesrequest?authcode=${logincon.box.read('AppCode')}";

      Map<String, dynamic> addleave = {
        'EmpID': logincon.box.read("UserId"),
        'FromDate': fromdatecontroller.text,
        'Remarks': remarkcontroller.text,
        'LeaveType': 1,
        'WFStatus': "P",
        'ishalfday': ishalfday,
        'issubmit': issubmit,
      };

      print("FFFF + $addleave");

      final reponson = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(addleave));

      if (reponson.statusCode == 200) {
        final data = jsonDecode(reponson.body);

        leaverequestResponson.iserror = data["isError"];
        leaverequestResponson.errormsg = data["errorMsg"];
        leaverequestResponson.dataadded = data["DataAdded"];

        if (leaverequestResponson.dataadded == true) {
          print("data sucssfully");
          allleave.FectchLeaverequest();
          allleave.issumbitlist.refresh();
          fromdatecontroller.clear();
          remarkcontroller.clear();
        } else {
          print("something went worng");
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
