import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/LeaveWid.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/view/pages/leaveWidgets/leavewid.dart';

class Leavebulider1 extends StatelessWidget {
  const Leavebulider1({super.key});

  @override
  Widget build(BuildContext context) {
    final approved = Get.put(Allleavecontroller());
    return Obx(() {
      if (approved.approvedlist.isEmpty) {
        return Center(
          child: Text("No Approved Leave is found"),
        );
      } else {
        return ListView.builder(
          itemCount: approved.approvedlist.length,
          itemBuilder: (context, index) {
            var approvedlist = approved.approvedlist[index];
            return Leaveapproved(
              allleavemodel: approvedlist,
            );
          },
        );
      }
    });
  }
}
