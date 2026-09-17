import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hrapp/bulider/upcomingleaveBulider.dart';
import 'package:hrapp/features/leave/controllers/LeaveController.dart';
import 'package:shimmer/shimmer.dart';

class Upcomingleave extends StatelessWidget {
  const Upcomingleave({super.key});

  @override
  Widget build(BuildContext context) {
    // final leave = Get.put(Leavecontroller());

    return Scaffold(body: Upcomingleavebulider());
  }
}
