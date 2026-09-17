import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/bulider/SaveLeaveBulider.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Saveleave extends StatelessWidget {
  const Saveleave({super.key});

  @override
  Widget build(BuildContext context) {
    final Savedleave = Get.put(Allleavecontroller());

    // Savedleave.FectchLeaverequest();
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[100],
      //   title: Text(
      //     "Daft Leave",
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      //   ),
      //   elevation: 5,
      //   excludeHeaderSemantics: true,
      //   centerTitle: true,
      // ),
      body: Obx(() {
        if (Savedleave.isloading.value) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else {
          return SaveLeaveBuilder();
        }
      }),
    );
  }
}
