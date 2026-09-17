import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/leavedatawid.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';

class Leavedatabuilder extends StatelessWidget {
  const Leavedatabuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());
    controller.getdashboardDetails();
    return Obx(() {
      if (controller.leavedatalist.isEmpty) {
        return Center(
          child: Text("No Leave Balance found"),
        );
      } else {
        return ListView.builder(
            itemCount: controller.leavedatalist.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var leavedata = controller.leavedatalist[index];

              return Leavedatawid(
                leaveDataModel: leavedata,
              );
            });
      }
    });
  }
}
