import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;

class UserDeleteController extends GetxController {
  final isLoading = false.obs; // optional for loading state
  final box = GetStorage();

  Future<bool> deleteUser() async {
    isLoading.value = true;

    try {
      final authCode = box.read("AppCode");

      String? accessToken =
          await Rs_hrms_config.storage.read(key: "accessToken");

      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UserDelete";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "authcode": authCode,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final isDelete = data["IsDelete"] ?? false;

        if (isDelete) {
          Get.snackbar(
            "Success",
            "User deleted successfully",
          );

          box.remove("UserId");
          box.remove("isauth");

          await Rs_hrms_config.storage.deleteAll();

          Get.offAll(() => Newloginscreen());

          return true;
        }

        return false;
      }

      if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          return await deleteUser();
        }

        await Rs_hrms_config.storage.deleteAll();
        Get.offAll(() => Newloginscreen());

        return false;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
