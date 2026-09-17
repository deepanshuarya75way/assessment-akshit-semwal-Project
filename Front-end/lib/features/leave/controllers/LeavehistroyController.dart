import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hrapp/features/leave/models/LeaveHistroy.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/view/pages/testscreen.dart';
import 'package:http/http.dart' as http;

class Leavehistroycontroller extends GetxController {
  Logincontroller logincontroller = Get.put(Logincontroller());

  LeaveHistroyReponse leaveHistroyReponse = LeaveHistroyReponse();
  var pastApprovedlist = <Leavehistroy>[].obs;

  var pastPendinglist = <Leavehistroy>[].obs;

  var pastrejectlist = <Leavehistroy>[].obs;

  Future<void> FeatchPastLeave() async {
    try {
      int? empid = logincontroller.box.read("UserId");
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Leavehistroy?EmpId=$empid&authcode=${logincontroller.box.read('AppCode')}";

      final reponse = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"});

      if (reponse.statusCode == 200) {
        pastApprovedlist.clear();
        pastPendinglist.clear();
        pastrejectlist.clear();
        final data = jsonDecode(reponse.body);

        leaveHistroyReponse.iserror = data["isError"];

        final PastLeavelist = data["allLeave"];

        final approvedlist = PastLeavelist["approvedlist"];

        final pendinglist = PastLeavelist["pendinglist"];

        final rejectlist = PastLeavelist["rejectedlist"];

        //////////////////////////////////////////////////////
        ///
        ///

        // final alist = data['allLeave"']['approvedlist'];
        // final plist = data["allLeave"]["pendinglist"];
        // final rlist = data["allLeave"]["rejectedlist"];

        for (var element in approvedlist) {
          Leavehistroy leavehistroy = Leavehistroy();

          leavehistroy.id = element['ID'];
          leavehistroy.fromDate = element["FromDate"];
          leavehistroy.todate = element["ToDate"];
          leavehistroy.requiredDocument = element["RequiredDocument"];
          leavehistroy.Leavedays = element['Leavedays'];

          leavehistroy.wfstatus = element['wfstatus'];
          leavehistroy.Remarks = element['Remarks'];
          leavehistroy.LeaveType = element['LeaveType'];
          leavehistroy.ishalfday = element['ishalfday'];
          leavehistroy.issumbit = element['issumbit'];

          pastApprovedlist.add(leavehistroy);
        }

        for (var element in pendinglist) {
          Leavehistroy leavehistroy = Leavehistroy();

          leavehistroy.id = element['ID'];
          leavehistroy.fromDate = element["FromDate"];
          leavehistroy.todate = element["ToDate"];
          leavehistroy.requiredDocument = element["RequiredDocument"];
          leavehistroy.Leavedays = element['Leavedays'];

          leavehistroy.wfstatus = element['wfstatus'];
          leavehistroy.Remarks = element['Remarks'];
          leavehistroy.LeaveType = element['LeaveType'];
          leavehistroy.ishalfday = element['ishalfday'];
          leavehistroy.issumbit = element['issumbit'];

          pastPendinglist.add(leavehistroy);
        }

        for (var element in pendinglist) {
          Leavehistroy leavehistroy = Leavehistroy();

          leavehistroy.id = element['ID'];
          leavehistroy.fromDate = element["FromDate"];
          leavehistroy.todate = element["ToDate"];
          leavehistroy.requiredDocument = element["RequiredDocument"];
          leavehistroy.Leavedays = element['Leavedays'];

          leavehistroy.wfstatus = element['wfstatus'];
          leavehistroy.Remarks = element['Remarks'];
          leavehistroy.LeaveType = element['LeaveType'];
          leavehistroy.ishalfday = element['ishalfday'];
          leavehistroy.issumbit = element['issumbit'];

          pastPendinglist.add(leavehistroy);
        }

        for (var element in rejectlist) {
          Leavehistroy leavehistroy = Leavehistroy();

          leavehistroy.id = element['ID'];
          leavehistroy.fromDate = element["FromDate"];
          leavehistroy.todate = element["ToDate"];
          leavehistroy.requiredDocument = element["RequiredDocument"];
          leavehistroy.Leavedays = element['Leavedays'];

          leavehistroy.wfstatus = element['wfstatus'];
          leavehistroy.Remarks = element['Remarks'];
          leavehistroy.LeaveType = element['LeaveType'];
          leavehistroy.ishalfday = element['ishalfday'];
          leavehistroy.issumbit = element['issumbit'];

          pastrejectlist.add(leavehistroy);
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
