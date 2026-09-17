import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/bulider/halfdaybulider.dart';
import 'package:hrapp/features/leave/controllers/Halfdaycontroller.dart';

class HalfDayPage extends StatelessWidget {
  const HalfDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final halfController = Get.put(Halfdaycontroller());

    // Ensure the API call is made once
    halfController.gethalfdaylist();

    return Scaffold(
        // backgroundColor: Colors.white,

        body: Obx(() {
      if (halfController.loading.value) {
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        return Halfdaybulider();
      }
    }));
  }
}
