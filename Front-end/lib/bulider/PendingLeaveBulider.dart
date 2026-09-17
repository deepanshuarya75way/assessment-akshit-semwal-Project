import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Widget/PendingWid.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Pendingleavebulider extends StatelessWidget {
  const Pendingleavebulider({super.key});

  @override
  Widget build(BuildContext context) {
    final pendding = Get.put(Allleavecontroller());

    // pendding.FectchLeaverequest();

    return Obx(() {
      if (pendding.pendinglist.isEmpty) {
        return Center(
          child: Text("No Pending Leave is found"),
        );
      } else {
        return ListView.builder(
          itemCount: pendding.pendinglist.length,
          itemBuilder: (context, index) {
            var penddinglist = pendding.pendinglist[index];
            return Pendingwid(
              allleavemodel: penddinglist,
            );
          },
        );
      }
    });
  }
}
