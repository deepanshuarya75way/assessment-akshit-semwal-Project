import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/timesheet/models/TimeSheetModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/common/Help_function.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';

import 'package:hrapp/view/navbar.dart';
import 'package:http/http.dart' as http;

class Gettimesheetcontroller extends GetxController {
  @override
  void onInit() {
    GetTimeSheet();
    super.onInit();
  }

  RxList<Timesheetmodel> timesheetlist = <Timesheetmodel>[].obs;

  RxList<TimeSheetList> FeatchtimeSheetList = <TimeSheetList>[].obs;

  RxBool isLoading = false.obs;

  RxBool isFetchLoading = false.obs;

  TextEditingController taskcontroller = TextEditingController();

  TextEditingController totalhourcontroller = TextEditingController();

  TextEditingController projectcodecontroller = TextEditingController();

  TextEditingController notescontroller = TextEditingController();

  GetStorage box = GetStorage();

  Future<void> GetTimeSheet() async {
    isLoading.value = true;

    final empId = box.read("UserId");
    final appcode = box.read("AppCode");
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/GetTimeSheetView?authcode=$appcode";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });

      if (res.statusCode == 200) {
        timesheetlist.clear();
        final data = jsonDecode(res.body);
        print(data);
        final timeSheetList = data["getTimeSheetDataModels"];
        print(timeSheetList);

        for (var element in timeSheetList) {
          Timesheetmodel timesheetmodel = Timesheetmodel();

          timesheetmodel.timesheetid = element["TimesheetId"];
          timesheetmodel.EmpId = element["EmpId"];
          timesheetmodel.EmployeeName = element["EmployeeName"];
          timesheetmodel.workDate = element["workDate"];
          timesheetmodel.clockIn = element["ClockIn"];
          timesheetmodel.projectCode = element["projectCode"];
          timesheetmodel.issumbit = element["issumbit"];

          // timesheetmodel.issumbit = element["issumbit"] == true ||
          //     element["issumbit"] == "true" ||
          //     element["issumbit"] == 1 ||
          //     element["issumbit"] == "1";
          timesheetlist.add(timesheetmodel);
        }
        print(timesheetlist.length.toString());
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await GetTimeSheet(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      }
      print(res.body);
    } catch (ex) {
      print(ex.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> FetchTimeSheet(int TimeId) async {
    isFetchLoading.value = true;
    final controller = Get.put(Logincontroller());

    final appcode = controller.box.read("AppCode");
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/GetTimeSheetData?timeid=$TimeId&authcode=$appcode";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (res.statusCode == 200) {
        FeatchtimeSheetList.clear();
        final data = jsonDecode(res.body);
        final timeSheetList = data["getTimeSheetDataModels"];

        for (var element in timeSheetList) {
          TimeSheetList timeSheetList = TimeSheetList();
          timeSheetList.id = element['ID'];

          timeSheetList.TimesheetId = element["TimesheetId"];
          timeSheetList.task = element["task"];
          timeSheetList.workDate = element["workDate"];
          timeSheetList.projectCode = element["projectCode"];
          timeSheetList.Notes = element["Notes"];
          timeSheetList.totalHour = element["totalHour"];

          FeatchtimeSheetList.add(timeSheetList);
        }
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      isFetchLoading.value = false;
    }
  }

  Future<void> PostTimeSheet(int timeid) async {
    isLoading.value = true;

    final controller = Get.put(Logincontroller());

    final appcode = controller.box.read("AppCode");
    String? accessToken = await Rs_hrms_config.storage.read(
      key: "accessToken",
    );
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/PostTimeSheet?authcode=$appcode";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // <-- important
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "Task": taskcontroller.text,
          "totalHour": totalhourcontroller.text,
          "ProjectCode": selectedProject.value,
          "Notes": notescontroller.text,
          "TimeSheetID": timeid,
        }),
      );
      FeatchtimeSheetList.refresh();
      print(res.body);

      if (res.statusCode == 200) {
        print(res.body);
        print("sucess");
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await PostTimeSheet(timeid); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("error");
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> SumbitTimeSheet(int timeid) async {
    try {
      isLoading.value = true;
      final appcode = box.read("AppCode");

      final emp = box.read("UserId");
      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/IsSumbitTimeSheet?Timeid=$timeid&authcode=$appcode';
      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );
      final res = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
      print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final result = data["Setflow"];

        if (result == false) {
          print("sucess");
          Get.snackbar(
            "Success 🎉",
            "Timesheet submitted successfully!",
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(12),
            duration: Duration(seconds: 2),
          );

          Get.offAll(() => Navbar());
        } else if (res.statusCode == 401) {
          bool success = await refreshApi();

          if (success) {
            await SumbitTimeSheet(timeid); // Retry API
            return;
          } else {
            // Refresh token expired
            await Rs_hrms_config.storage.deleteAll();
            Get.offAll(() => Newloginscreen());
          }
        } else {
          print("error");
        }
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> DeleteTimeSheet(int id, int timeid) async {
    try {
      final appcode = box.read("AppCode");

      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/TimeSheetsDelete?id=$id&authcode=$appcode";
      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );
      final res = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);
        final IsDelete = data['IsDelete'];

        if (IsDelete) {
          await FetchTimeSheet(timeid);
          Get.snackbar('Success', 'Leave deleted successfully');
        } else {
          Get.snackbar('Failed', 'Error');
        }
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await DeleteTimeSheet(id, timeid); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {}
    } catch (ex) {
      print(ex.toString());
    }
  }
}
