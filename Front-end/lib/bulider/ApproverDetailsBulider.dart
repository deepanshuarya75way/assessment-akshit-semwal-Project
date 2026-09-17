import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Widget/approverDetailsWid.dart';
import 'package:hrapp/bulider/actvities.dart';
import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';
import 'package:http/http.dart';

class Approverdetailsbulider extends StatelessWidget {
  const Approverdetailsbulider({super.key});

  @override
  Widget build(BuildContext context) {
    Approvaldetailscontroller approvaldetailscontroller =
        Get.put(Approvaldetailscontroller());

    return Obx(() {
      if (approvaldetailscontroller.approvalerlist.isEmpty) {
        return Center(
          child: Text("No new notifications"),
        );
      } else {
        return ListView.builder(
            itemCount: approvaldetailscontroller.approvalerlist.length,
            itemBuilder: (context, index) {
              var approverdetails =
                  approvaldetailscontroller.approvalerlist[index];

              return Approverdetailswid(
                approvalDetails: approverdetails,
              );
            });
      }
    });
  }
}
