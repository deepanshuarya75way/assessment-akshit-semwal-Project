import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/profile/models/ProfileModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:intl/intl.dart';

final controller = Get.put(Logincontroller());

class Profilecontroller extends GetxController {
  // ✅ SINGLE controller only
  final TextEditingController DOBController = TextEditingController();

  var dob = ''.obs;
  var isLoading = false.obs;
  var ispasswordchange = false.obs;

  Profilemodel profilemodel = Profilemodel();
  ProfileModelReponse profileModelReponse = ProfileModelReponse();

  Uint8List? imageBytes;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController OldPassword = TextEditingController();
  final TextEditingController NewPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController ContactNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    GetProfile(); // load data
  }

  @override
  void onClose() {
    // DOBController.dispose();
    super.onClose();
  }

  // ✅ DATE PICKER (SAFE)

  Future<void> pickDOB(BuildContext context) async {
    DateTime initial = DateTime(2000);

    /// ✅ 1. User selected DOB (PRIORITY)
    if (dob.value.trim().isNotEmpty) {
      try {
        initial = DateFormat('dd/MM/yyyy').parse(dob.value);
      } catch (e) {
        initial = DateTime(2000);
      }
    }

    /// ✅ 2. API DOB (fallback)
    else if (profilemodel.DOB != null && profilemodel.DOB!.isNotEmpty) {
      try {
        initial = DateFormat('yyyy-MM-dd').parse(profilemodel.DOB!);
      } catch (e) {
        initial = DateTime(2000);
      }
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dob.value = DateFormat('dd/MM/yyyy').format(picked);
      DOBController.text = dob.value;
    }
  }

  // ✅ GET PROFILE
  Future<void> GetProfile() async {
    try {
      isLoading.value = true;

      final empid = controller.box.read("UserId");

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      print(accessToken);

      final String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/userdetails";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "authcode": controller.box.read("AppCode"),
        }),
      );

      print(response.body.toString());

      if (response.statusCode == 200) {
        final extractedData = jsonDecode(response.body);
        final user = extractedData["UserProFileData"];

        // ✅ Basic response
        profileModelReponse.iserror = extractedData["isError"];
        profileModelReponse.errmag = extractedData['errorMsg'];

        // ✅ Assign data
        profilemodel.id = user["ID"];
        profilemodel.empcode = user["EmpCode"];
        profilemodel.empname = user["EmpName"];
        profilemodel.email_work = user["Email_work"];
        profilemodel.designation = user["Department"];
        profilemodel.department = user["Designation"];
        profilemodel.currentaddress = user["CurrentAddress"];
        profilemodel.permanentaddress = user["PermanentAddress"];
        profilemodel.gender = user["Gender"];
        profilemodel.userimage = user["ProfilePic"];
        profilemodel.image = user["ProfilePic"];
        profilemodel.Usercurency = user["Currency"];
        profilemodel.DOB = user["DOB"];
        profilemodel.MobileNo = user["ContactNumber"];

        profileModelReponse.profilemodel = profilemodel;

        // ✅ Image decode
        if (profilemodel.image != null && profilemodel.image!.isNotEmpty) {
          imageBytes = base64Decode(profilemodel.image!);
        }

        // 🔥🔥 MAIN FIX (DOB FORMAT)
        if (profilemodel.DOB != null && profilemodel.DOB!.trim().isNotEmpty) {
          try {
            // API format → yyyy-MM-dd
            DateTime parsedDate =
                DateFormat('yyyy-MM-dd').parse(profilemodel.DOB!);

            // UI format → dd/MM/yyyy
            String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

            DOBController.text = formattedDate;
            dob.value = formattedDate;
          } catch (e) {
            DOBController.text = '';
            dob.value = '';
          }
        } else {
          DOBController.text = '';
          dob.value = '';
        }
      } else if (response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await GetProfile(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("Failed to load profile data.");
        // Get.snackbar("Error", "Failed to load profile");
      }
    } catch (ex) {
      print("Error: ${ex.toString()}");
      // Get.snackbar("Error", ex.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ UPDATE PROFILE
  Future<void> updateProfile({bool isRetry = false}) async {
    try {
      isLoading.value = true;

      // ✅ UI → API format
      String dobForSQL = "";
      if (dob.value.trim().isNotEmpty) {
        try {
          final dobDate = DateFormat('dd/MM/yyyy').parse(dob.value.trim());
          dobForSQL = DateFormat('yyyy-MM-dd').format(dobDate);
        } catch (_) {
          showError("Invalid date format");
          return;
        }
      }

      final accessToken = await Rs_hrms_config.storage.read(key: "accessToken");
      if (accessToken == null) {
        await Rs_hrms_config.storage.deleteAll();
        Get.offAll(() => Newloginscreen());
        return;
      }

      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/ProfileUpdate";

      final requestBody = {
        "Authcode": controller.box.read("AppCode"),
        "PermanentAddress": AddressController.text.trim().isNotEmpty
            ? AddressController.text.trim()
            : (profilemodel.permanentaddress ?? ""),
        "ContactNumber": ContactNumberController.text.trim().isNotEmpty
            ? ContactNumberController.text.trim()
            : (profilemodel.MobileNo ?? ""),
        "DOB": dobForSQL.isNotEmpty ? dobForSQL : (profilemodel.DOB ?? ""),
      };

      debugPrint('Update profile payload: $requestBody');

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("Status Code: ${res.statusCode}");

      if (res.statusCode == 200) {
        Get.snackbar(
          "Success 🎉",
          "Profile updated successfully",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          snackStyle: SnackStyle.floating,
          icon: const Icon(Icons.person, color: Colors.white),
          duration: const Duration(seconds: 3),
          boxShadows: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        );

        await GetProfile();

        Timer(const Duration(seconds: 2), () {
          Get.back();
        });
      } else if (res.statusCode == 401) {
        if (isRetry) {
          // Already retried once, avoid infinite loop
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
          return;
        }

        final success = await refreshApi();
        if (success) {
          await updateProfile(isRetry: true); // Retry once
        } else {
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        showError("something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ PASSWORD CHANGE
  Future<void> PasswordChange() async {
    ispasswordchange.value = true;

    try {
      final empid = controller.box.read("UserId");

      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/passwordchange";
      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode({
          "oldpassword": OldPassword.text,
          "newpassword": NewPassword.text,
          "ID": empid,
          "authcode": controller.box.read('AppCode')
        }),
      );

      print("Status Code: ${res.statusCode}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        if (data["isPasswordChanged"] == true) {
          Get.snackbar(
            "Success",
            "Password changed successfully",
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            margin: EdgeInsets.all(12),
            borderRadius: 10,
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: Duration(seconds: 3),
          );

          Timer(const Duration(seconds: 2), () {
            Get.back();
          });
        } else {
          showError("Password change failed");
        }
      } else if (res.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await PasswordChange(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        showError("Incorrect Old Password");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      ispasswordchange.value = false;
    }
  }
}

void showError(String message) {
  Get.snackbar(
    "Error ❌",
    message,
    snackPosition: SnackPosition.top,
    backgroundColor: Colors.red.shade600,
    colorText: Colors.white,
    borderRadius: 12,
    margin: EdgeInsets.all(12),
    snackStyle: SnackStyle.floating,
    icon: Icon(Icons.error_outline, color: Colors.white),
  );
}
