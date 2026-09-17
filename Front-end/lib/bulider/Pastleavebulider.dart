import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/Pastleavewid.dart';
import 'package:hrapp/features/leave/controllers/LeaveController.dart';

class Pastleavebulider extends StatelessWidget {
  const Pastleavebulider({super.key});

  @override
  Widget build(BuildContext context) {
    final pastlist = Get.put(Leavecontroller(), permanent: true);
    return Obx(() {
      if (pastlist.pastleave.isEmpty) {
        return Center(child: Text("No Pastleave list is found"));
      } else {
        return ListView.builder(
            itemCount: pastlist.pastleave.value.length,
            itemBuilder: (context, index) {
              var past = pastlist.pastleave.value[index];
              return Pastleavewid(
                upcomingandpastleavemodel: past,
              );
            });
      }
    });
  }
}
