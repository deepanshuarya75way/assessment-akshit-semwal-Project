import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/RejectWid.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Rejectbulider extends StatelessWidget {
  const Rejectbulider({super.key});

  @override
  Widget build(BuildContext context) {
    final reject = Get.put(Allleavecontroller());
    return Obx(() {
      if (reject.rejectlist.isEmpty) {
        return Center(
          child: Text("No Reject Leave is found"),
        );
      } else {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: reject.rejectlist.value.length,
            itemBuilder: (context, index) {
              var rejectlist = reject.rejectlist[index];
              return Rejectwid(
                allleavemodel: rejectlist,
              );
            });
      }
    });
  }
}
