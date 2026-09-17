import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/leave/controllers/Halfdaycontroller.dart';

import 'package:hrapp/view/halfdaywidget/halfdaywid.dart';

class Halfdaybulider extends StatelessWidget {
  const Halfdaybulider({super.key});

  @override
  Widget build(BuildContext context) {
    final halfController = Get.put(Halfdaycontroller());

    // halfController.gethalfdaylist();

    return Obx(() {
      if (halfController.halfdaylist.isEmpty) {
        return const Center(
          child: Center(
            child: Text("No HalfDay list is found"),
          ),
        );
      }

      return ListView.builder(
          itemCount: halfController.halfdaylist.length,
          itemBuilder: (context, index) {
            var halfday = halfController.halfdaylist[index];
            return Halfdaywid(
              halfdaylistmodel: halfday,
            );
          });
    });
  }
}
