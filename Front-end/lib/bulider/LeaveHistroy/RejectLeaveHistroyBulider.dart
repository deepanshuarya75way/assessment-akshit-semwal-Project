import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/LeaveHistroy/Rejectleavehostroywid.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';

class Rejectleavehistroybulider extends StatelessWidget {
  const Rejectleavehistroybulider({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());

    return Obx(() {
      if (leavehistroycontroller.pastrejectlist.isEmpty) {
        return Center(
          child: Text("No Past Reject Leave is found"),
        );
      } else {
        return ListView.builder(
            itemCount: leavehistroycontroller.pastrejectlist.value.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var rejectlist = leavehistroycontroller.pastrejectlist[index];

              return Rejectleavehostroywid(
                leavehistroy: rejectlist,
              );

              // return Approvedleavehistroywid(
              //   leavehistroy: approvedlist,
              // );
            });
      }
    });
  }
}
