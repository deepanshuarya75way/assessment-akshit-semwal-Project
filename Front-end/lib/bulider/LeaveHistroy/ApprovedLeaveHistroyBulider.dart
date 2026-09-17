import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/LeaveHistroy/approvedleavehistroywid.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';
import 'package:hrapp/view/pages/leavepage.dart';

class Approvedleavehistroybulider extends StatelessWidget {
  const Approvedleavehistroybulider({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());
    return Obx(() {
      if (leavehistroycontroller.pastApprovedlist.isEmpty) {
        return Center(
          child: Text("No Past Approved Leave is found"),
        );
      } else {
        return ListView.builder(
            itemCount: leavehistroycontroller.pastApprovedlist.value.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var approvedlist = leavehistroycontroller.pastApprovedlist[index];

              return Approvedleavehistroywid(
                leavehistroy: approvedlist,
              );
            });
      }
    });
  }
}
