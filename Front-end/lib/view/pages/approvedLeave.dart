import 'package:flutter/material.dart';
import 'package:hrapp/bulider/leavebulider.dart';

class Approvedleave extends StatelessWidget {
  const Approvedleave({super.key});

  @override
  Widget build(BuildContext context) {
    // final approved = Get.put(Allleavecontroller());

    // approved.FectchLeaverequest();
    return Scaffold(body: Leavebulider1());
  }
}
