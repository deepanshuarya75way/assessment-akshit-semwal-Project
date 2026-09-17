import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/bulider/PendingLeaveBulider.dart';
import 'package:hrapp/bulider/leavebulider.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';

class Pendingleave extends StatelessWidget {
  const Pendingleave({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Pendingleavebulider());
  }
}
