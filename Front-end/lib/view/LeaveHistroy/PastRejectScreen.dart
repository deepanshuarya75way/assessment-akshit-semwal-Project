import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/bulider/LeaveHistroy/RejectLeaveHistroyBulider.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';

class Pastrejectscreen extends StatelessWidget {
  const Pastrejectscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());

    return Scaffold(body: Obx(() {
      if (leavehistroycontroller.pastPendinglist.isEmpty) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Palette.Kmain,
          ),
        );
      } else {
        return Rejectleavehistroybulider();
      }
    }));
  }
}
