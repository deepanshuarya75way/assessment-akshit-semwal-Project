import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/leave/models/LeaveTypeModel.dart';
import 'package:http/http.dart' as http;

class LeaveTypeController extends GetxController {
  @override
  void onInit() {
    getLeaveType();
    super.onInit();
  }

  RxList<Leavetypemodel> leaveTypeList = <Leavetypemodel>[].obs;

  Future<void> getLeaveType() async {
    GetStorage box = GetStorage();

    final appcode = box.read("AppCode");

    final userid = box.read("UserId");
    try {
      final url =
          "https://rs-apps.online/Rs-HrmsApi/api/HRMSWEBAPI/LeaveType?id=$userid";

      final res = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"Authcode": appcode}));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);

        leaveTypeList.clear();

        final leaveType = data["leave_Type_Models"];

        for (var element in leaveType) {
          Leavetypemodel leavetypemodel = Leavetypemodel();

          leavetypemodel.id = element["LeaveID"];
          leavetypemodel.leavetype = element["LeaveType"];

          leaveTypeList.add(leavetypemodel);
        }

        print("sucess");
      } else {
        print("er ror");
      }

      print(res.body);
    } catch (ex) {
      print("Error: $ex");
    }
  }
}
