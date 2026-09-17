import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/UpcomingLeavewid.dart';
import 'package:hrapp/features/leave/controllers/LeaveController.dart';

class Upcomingleavebulider extends StatelessWidget {
  const Upcomingleavebulider({super.key});

  @override
  Widget build(BuildContext context) {
    final leavelist = Get.put(Leavecontroller());

    return Obx(() {
      if (leavelist.upcomingleave.isEmpty)
        return Center(
          child: Text("No Upcomingleave list found "),
        );

      return ListView.builder(
          itemCount: leavelist.upcomingleave.length,
          itemBuilder: (context, index) {
            var upcomingleave = leavelist.upcomingleave[index];
            return Upcomingleavewid(
              upcomingandpastleavemodel: upcomingleave,
            );
          });
    });
  }
}
