import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/LeaveHistroy/PastLeaveHistroywid.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';

class Pastleavehistroybulider extends StatelessWidget {
  const Pastleavehistroybulider({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());
    return Obx(() {
      if (leavehistroycontroller.pastPendinglist.isEmpty) {
        return Center(
          child: Text("No Past Pending Leave is found"),
        );
      } else {
        return ListView.builder(
            itemCount: leavehistroycontroller.pastPendinglist.value.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var pendinglist = leavehistroycontroller.pastPendinglist[index];

              return Pastleavehistroywid(
                leavehistroy: pendinglist,
              );

              // return Approvedleavehistroywid(
              //   leavehistroy: approvedlist,
              // );
            });
      }
    });
  }
}
