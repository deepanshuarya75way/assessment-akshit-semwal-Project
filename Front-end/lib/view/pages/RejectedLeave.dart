import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/bulider/leavebulider.dart';
import 'package:hrapp/bulider/rejectBulider.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Rejectedleave extends StatelessWidget {
  const Rejectedleave({super.key});

  @override
  Widget build(BuildContext context) {
    final allleave = Get.put(Allleavecontroller());

    return Scaffold(body: Rejectbulider());
  }
}
