import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/leave/models/LeaveHistroy.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/bulider/LeaveHistroy/ApprovedLeaveHistroyBulider.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';

class Pastapprovedscreen extends StatelessWidget {
  const Pastapprovedscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());

    return Scaffold(body: Obx(() {
      if (leavehistroycontroller.pastApprovedlist.isEmpty) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Palette.Kmain,
          ),
        );
      } else {
        return Approvedleavehistroybulider();
      }
    }));
  }
}
