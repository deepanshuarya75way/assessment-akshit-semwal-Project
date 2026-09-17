import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Deletecontroller extends GetxController {
  final box = GetStorage();
  final Allleavecontroller savedLeave =
      Get.find<Allleavecontroller>(); // Use Get.find

  Future<void> delete(int id) async {
    try {
      final empid = box.read('UserId');
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Delete?EMPID=$empid&leaveid=$id&authcode=${box.read('AppCode')}";

      // Use http.delete for deletion
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isError = data["isError"];
        final errorMsg = data["errorMsg"];
        final deletedSuccessfully = data["deletedsucessfully"];

        if (deletedSuccessfully == true) {
          await savedLeave.FectchLeaverequest(); // Refetch leaves
          Get.snackbar('Success', 'Leave deleted successfully');
          print("Deleted Successfully");
        } else {
          Get.snackbar('Error', errorMsg ?? 'Failed to delete leave');
          print("Error: $errorMsg");
        }
      } else {
        Get.snackbar('Error', 'Failed to delete leave: ${response.statusCode}');
        print("Error: Status code ${response.statusCode}");
      }
    } catch (ex) {
      Get.snackbar('Error', 'An error occurred: $ex');
      print(ex.toString());
    }
  }

  void refreshScreen() {
    update(); // Rebuilds all GetBuilder widgets using this controller
  }
}
