import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;

class RoleController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getUserRole();
  }

  RxBool isDelete = false.obs;
  RxBool attendanceOutsideGeoLocation = false.obs;
  RxBool enableTimesheet = false.obs;
  RxBool enableLocationTracking = false.obs;

  Future<void> getUserRole() async {
    try {
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UserRole?authcode=${box.read("AppCode")}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(data);

        isDelete.value = data["userdetails"]["isDelete"];
        attendanceOutsideGeoLocation.value =
            data["userdetails"]["AttendanceOutsideGeoLocation"];
        enableTimesheet.value = data["userdetails"]["EnableTimesheet"];
        enableLocationTracking.value =
            data["userdetails"]["EnableLocationTracking"];

        // optional storage
        box.write("EnableTimesheet", enableTimesheet.value);

        print("Timesheet Permission: ${enableTimesheet.value}");
      }
    } catch (e) {
      print("Role API error: $e");
    }
  }
}
