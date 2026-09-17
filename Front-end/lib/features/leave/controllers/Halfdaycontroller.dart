import 'dart:convert';

import 'package:get/get.dart';
import 'package:hrapp/features/leave/models/Halfdaylistmodel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:http/http.dart' as http;

class Halfdaycontroller extends GetxController {
  @override
  // void onInit() {
  //   gethalfdaylist();
  //   super.onInit();
  // }

  final halfdaylist = <Halfdaylistmodel>[].obs;
  Halfdaylistreponse halfdaylistreponse = Halfdaylistreponse();
  var loading = false.obs;
  final controller = Get.put(Logincontroller());

  Future<void> gethalfdaylist() async {
    loading.value = true;
    try {
      int empid = controller.box.read("UserId");
      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/listday?empid=$empid&authcode=${controller.box.read('AppCode')}";

      final reponse = await http.get(Uri.parse(url));

      print(reponse.body);

      if (reponse.statusCode == 200) {
        print('Loading started');

        halfdaylist.clear();
        final data = jsonDecode(reponse.body);

        halfdaylistreponse.isError = data["isError"];
        halfdaylistreponse.errorMsg = data["errorMsg"];

        final halfday = data["isHalfdayModelLists"];

        for (int i = 0; i < halfday.length; i++) {
          Halfdaylistmodel halfdaylistmodel = Halfdaylistmodel();

          halfdaylistmodel.empid = halfday[i]["EmpID"];
          halfdaylistmodel.id = halfday[i]["ID"];
          halfdaylistmodel.fromdate = halfday[i]["fromdate"];
          halfdaylistmodel.remarks = halfday[i]["remarks"];
          halfdaylistmodel.leavetype = halfday[i]["leavetype"];
          halfdaylistmodel.isHalfDay = halfday[i]["IsHalfDay"];
          halfdaylistmodel.isSubmit = halfday[i]["isSubmit"];

          halfdaylist.add(halfdaylistmodel);
        }
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      // Ensure loading state is set to false after the operation is completed
      loading.value = false;

      print("loading is close");
    }
  }
}
