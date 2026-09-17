import 'dart:convert';

import 'package:get/get.dart';

import 'package:hrapp/features/leave/models/upcomingAndPastleavemodel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:http/http.dart' as http;

class Leavecontroller extends GetxController {
  final logincontrol = Get.put(Logincontroller());
  var upcomingleave = <Upcomingandpastleavemodel>[].obs;

  var pastleave = <Upcomingandpastleavemodel>[].obs;

  var isloading = false.obs;

  Future<void> Getleavedetails() async {
    isloading.value = true;
    UpcomingandpastleaveReponse upcomingandpastleaveReponse =
        new UpcomingandpastleaveReponse();

    try {
      int? empid = logincontrol.box.read("UserId");

      String url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/GetLeavesById?id=$empid';

      final reponse = await http.get(
        Uri.parse(url),
      );

      print(reponse.body.toString());

      if (reponse.statusCode == 200) {
        upcomingleave.clear();
        pastleave.clear();
        final data = jsonDecode(reponse.body);

        upcomingandpastleaveReponse.isError = data["isError"];
        upcomingandpastleaveReponse.errorMsg = data["errorMsg"];

        final List upcoming = data["upcomingLeavesList"];
        final List past = data["pastLeavesList"];

        for (int i = 0; i < upcoming.length; i++) {
          Upcomingandpastleavemodel upcomingandpastleavemodel =
              Upcomingandpastleavemodel();

          upcomingandpastleavemodel.id = upcoming[i]["ID"];
          upcomingandpastleavemodel.FromDate = upcoming[i]["FromDate"];
          upcomingandpastleavemodel.ToDate = upcoming[i]["ToDate"];
          upcomingandpastleavemodel.LeaveId = upcoming[i]["LeaveId"];
          upcomingandpastleavemodel.Remarks = upcoming[i]["Remarks"];
          upcomingandpastleavemodel.Leavedays = upcoming[i]["Leavedays"];
          upcomingandpastleavemodel.LeaveType = upcoming[i]["LeaveType"];
          upcomingandpastleavemodel.RequiredDocument =
              upcoming[i]["RequiredDocument"];
          upcomingandpastleavemodel.WFStatus = upcoming[i]["WFStatus"];

          upcomingandpastleavemodel.year = upcoming[i]["year"];
          upcomingandpastleavemodel.Month = upcoming[i]["Month"];

          upcomingleave.add(upcomingandpastleavemodel);
        }

        for (int t = 0; t < past.length; t++) {
          Upcomingandpastleavemodel upcomingandpastleavemodel =
              Upcomingandpastleavemodel();

          upcomingandpastleavemodel.id = past[t]["ID"];
          upcomingandpastleavemodel.FromDate = past[t]["FromDate"];
          upcomingandpastleavemodel.ToDate = past[t]["ToDate"];
          upcomingandpastleavemodel.LeaveId = past[t]["LeaveId"];
          upcomingandpastleavemodel.Remarks = past[t]["Remarks"];
          upcomingandpastleavemodel.Leavedays = past[t]["Leavedays"];
          upcomingandpastleavemodel.LeaveType = past[t]["LeaveType"];
          upcomingandpastleavemodel.RequiredDocument =
              past[t]["RequiredDocument"];
          upcomingandpastleavemodel.WFStatus = past[t]["WFStatus"];

          upcomingandpastleavemodel.year = past[t]["year"];
          upcomingandpastleavemodel.Month = past[t]["Month"];

          pastleave.add(upcomingandpastleavemodel);
        }
      } else {
        print("Failed to load leaves. Status: ${reponse.statusCode}");
      }
    } catch (ex) {
      print(ex.toString());
    }

    isloading.value = false;
  }
}
