import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/dashboard/models/DashboardModel.dart';
import 'package:hrapp/Widget/LeaveWid.dart';
import 'package:hrapp/Widget/leavedatawid.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/view/pages/leaveWidgets/leavewid.dart';

class Leavebulider extends StatelessWidget {
  const Leavebulider({super.key});

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
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var leavedata = controller.leavedatalist[index];

              return Leavebalance(
                leaveDataModel: leavedata,
              );
            });
      }
    });
  }
}
