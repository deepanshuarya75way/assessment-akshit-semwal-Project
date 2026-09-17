import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';
import 'package:hrapp/features/attendance/controllers/Attendencedetails%20controller.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/leave/controllers/Halfdaycontroller.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';

class Testscreen extends StatelessWidget {
  const Testscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Approvaldetailscontroller approvaldetailscontroller =
        Approvaldetailscontroller();

    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
            // controller.gethalfdaylist();
            // attendencedetailscontroller.GetAttendencedetails();

            approvaldetailscontroller.GetApprovaldetails();
          },
          child: Text("Test")),
    ));
  }
}
