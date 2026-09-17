import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/attendance/models/TimeLineModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;

class Timelinecontroller extends GetxController {
  TimelineModelReponse timelineModelReponse = TimelineModelReponse();
  Timelinemodel timelinemodel = Timelinemodel();

  final box = GetStorage();
  Future<void> getTimeline(int? screenid, int? recordid) async {
    try {
      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/ApprovalTimeLine?screenId=$screenid&recordId=$recordid&authcode=${box.read('AppCode')}';

      final res = await http.get(Uri.parse(url));
      print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        timelineModelReponse.isError = data['isError'];
        timelineModelReponse.errorMsg = data['errorMsg'];

        final element = data['approvalModel'];

        timelinemodel.Approval_Details_ID = element['Approval_Details_ID'];
        timelinemodel.ScreenID = element['ScreenID'];
        timelinemodel.RecordID = element['RecordID'];
        timelinemodel.Approver_User_Name = element['Approver_User_Name'];
        timelinemodel.Approval_Status = element['Approval_Status'];

        timelineModelReponse.TimeLine = timelinemodel;

        print("TimeLine: ${timelineModelReponse.TimeLine}");
        print("sucess");
      } else {
        print("error");
      }
    } catch (ex) {
      print("Error: $ex");
    }
  }
}
