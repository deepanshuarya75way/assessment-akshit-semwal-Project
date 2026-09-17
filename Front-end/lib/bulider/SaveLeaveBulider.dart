import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Widget/saveleavewid.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class SaveLeaveBuilder extends StatelessWidget {
  const SaveLeaveBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLeave = Get.put(Allleavecontroller());

    return Obx(() {
      // Check if data is loading

      // Check if the list is empty
      if (savedLeave.issumbitlist.isEmpty) {
        return Center(
          child: Text("No Saved list found."), // Show no data message
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: savedLeave.issumbitlist.value.length,
          itemBuilder: (context, index) {
            var saved = savedLeave.issumbitlist[index];
            return Saveleavewid(
              allleavemodel: saved, // Pass the leave model to the widget
            );
          },
        );
      }
    });
  }
}
