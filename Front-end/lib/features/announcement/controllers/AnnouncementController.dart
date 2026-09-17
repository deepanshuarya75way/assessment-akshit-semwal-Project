import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/announcement/models/Annoucement_model.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';

import 'package:hrapp/view/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final controller = Get.put(Dashboardcontroller());

class Announcementcontroller extends GetxController {
  @override
  void onInit() {
    FectchAnnouncement();

    // FectchOldAnnouncement();
    super.onInit();
  }

  void initData({
    required String title,
    required String message,
    required String publish,
    required String expiry,
  }) {
    titleController = TextEditingController(text: title);
    messageController = TextEditingController(text: message);

    publishDate.value = publish.split(" ")[0];
    expiryDate.value = expiry.split(" ")[0];
  }

  void clearData() {
    titleController.clear();
    messageController.clear();
    publishDate.value = "";
    expiryDate.value = "";
  }

  var publishDate = ''.obs;
  var expiryDate = ''.obs;
  var isChecked = 0.obs;
  RxBool status = false.obs;
  final RxList<bool> stat = <bool>[].obs;

  DateTime getInitialDate(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime.now();
    }

    try {
      return DateFormat('dd-MMM-yyyy').parse(date);
    } catch (e) {
      print("Invalid backend date: $date");
      return DateTime.now();
    }
  }

  Future<void> pickPublishDate(BuildContext context, String date) async {
    DateTime today = DateTime.now();

    DateTime initial;
    DateTime first;

    if (date.isEmpty) {
      // 🆕 New case
      initial = today;
      first = today;
    } else {
      // ✏️ Edit case
      try {
        initial = DateFormat('dd-MMM-yyyy').parse(date);

        // 🔥 allow past date selection
        first = DateTime(2000);
      } catch (e) {
        initial = today;
        first = today;
      }
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      publishDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

// Future<void> pickPublishDate(BuildContext context, String date) async {
//   DateTime today = DateTime.now();

//   DateTime initial;

//   if (date.isEmpty) {
//     initial = today;
//   } else {
//     try {
//       DateTime parsed = DateFormat('dd-MMM-yyyy').parse(date);

//       // 🔥 IMPORTANT FIX
//       if (parsed.isBefore(today)) {
//         initial = today;
//       } else {
//         initial = parsed;
//       }
//     } catch (e) {
//       initial = today;
//     }
//   }

//   DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: initial,
//     firstDate: today,
//     lastDate: DateTime(2035),
//   );

//   if (picked != null) {
//     publishDate.value = DateFormat('yyyy-MM-dd').format(picked);
//   }
// }

  DateTime parseAnyDate(String date) {
    try {
      // ✅ Try ISO first
      return DateTime.parse(date);
    } catch (_) {
      try {
        // ✅ Try backend format
        return DateFormat('dd-MMM-yyyy').parse(date);
      } catch (e) {
        throw Exception("Invalid date format: $date");
      }
    }
  }

  Future<void> pickExpiryDate(BuildContext context, String date) async {
    DateTime publish = parseAnyDate(publishDate.value);

    DateTime initial;
    DateTime first;

    if (date.isEmpty) {
      // 🆕 New case
      initial = publish;
      first = publish;
    } else {
      // ✏️ Edit case
      try {
        DateTime parsed = parseAnyDate(date);

        // 🔥 FIX: initial must be >= firstDate
        if (parsed.isBefore(publish)) {
          initial = publish;
        } else {
          initial = parsed;
        }

        // 🔥 allow old expiry selection
        first = DateTime(2000);
      } catch (e) {
        initial = publish;
        first = publish;
      }
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      expiryDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  RxList<AnnouncementModel> announcementList = <AnnouncementModel>[].obs;

  RxList<AnnouncementModel> OldannouncementList = <AnnouncementModel>[].obs;

  GetStorage box = GetStorage();
  RxBool isLoading = false.obs;

  Future<void> CreateAnnouncement() async {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "Message": messageController.text,
      "Title": titleController.text,
      "status": isChecked.value,
      "Category": "0",
      "TargetDeptId": 0,
      "PublishDate": publishDate.value,
      "ExpiryDate": expiryDate.value,
      "AttachmentUrl": "test",
      //CreatedBy
      "CreatedBy": box.read("UserId"),
      "authcode": box.read("AppCode")
    };
    String? accessToken = await Rs_hrms_config.storage.read(
      key: "accessToken",
    );

    try {
      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Announcements';

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(body),
      );

      print(res.body);
      print(body);
      print(jsonEncode(body));

      if (res.statusCode == 200) {
        print(res.body);
        print("success769769");
        print(jsonEncode(body));
        Get.snackbar(
          "Success",
          "Announcement created successfully 🎉",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );

        print(res.body);

        titleController.clear();
        messageController.clear();
        publishDate.value = '';
        expiryDate.value = '';

        Timer(Duration(seconds: 2), () async {
          Get.offAll(() => Navbar());
          await controller.getdashboardDetails();
        });

        controller.activitieslist.refresh();
      } else if (res.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await CreateAnnouncement(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print(res.body);
        print("error");
      }
    } catch (ex) {
      print("Error: $ex");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> FectchAnnouncement() async {
    isLoading.value = true;
    try {
      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UpcomingAnnouncements';

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"authcode": box.read("AppCode")}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        announcementList.clear(); // IMPORTANT

        final upcomingAnnouncement = data["UpcomingAnnouncement"];

        for (var element in upcomingAnnouncement) {
          AnnouncementModel announcementModel = AnnouncementModel();
          announcementModel.id = element["ID"];
          announcementModel.status = element["Status"];
          announcementModel.title = element["Title"];
          announcementModel.message = element["Message"];
          announcementModel.publishDate = element["PublishDate"];
          announcementModel.expiryDate = element["ExpiryDate"];
          announcementModel.createdBy = element["EMPNAME"];

          status.value = element["Status"];

          stat.add(element["Status"]);

          announcementList.add(announcementModel);
        }

        print("success");

        print(status.value);

        print(stat[0]);
        print(stat[1]);
        print(announcementList.length);
      } else if (res.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await FectchAnnouncement(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print(res.body);
        print("error");
      }
    } catch (ex) {
      print("Error: $ex");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> UpdatedAnnouncement(String title, String message,
      String PublishDate, String ExpiryDate, int id, bool status) async {
    isLoading.value = true;

    try {
      Map<String, dynamic> body = {
        "title": title,
        "message": message,
        "status": status,
        "category": 0,
        "targetDeptId": 0,
        "publishDate": publishDate.value,
        "expiryDate": expiryDate.value,
        "attachmentUrl": "test",
        "authcode": box.read("AppCode"),
        "ID": id
      };

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      print(body);

      print(jsonEncode(body));

      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UpdatedAnnouncements';

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        print(res.body);

        Get.snackbar(
          "Success",
          "Announcement updated successfully.",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(12),
          borderRadius: 10,
          duration: Duration(seconds: 3),
        );
        Timer(Duration(seconds: 2), () async {
          Get.offAll(() => Navbar());
          await controller.getdashboardDetails();

          controller.activitieslist.refresh();
        });
      } else if (res.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await UpdatedAnnouncement(
              title, message, PublishDate, ExpiryDate, id, status); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print(res.body);

        Get.snackbar(
          "Error",
          "Failed to update announcement",
          snackPosition: SnackPosition.bottom,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(12),
          borderRadius: 10,
          duration: Duration(seconds: 3),
        );
      }
    } catch (ex) {
      print("Error: $ex");
    } finally {
      isLoading.value = false;
    }
  }
}
