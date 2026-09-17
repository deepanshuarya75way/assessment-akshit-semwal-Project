import 'package:flutter/material.dart';
import 'package:hrapp/bulider/Pastleavebulider.dart';

class Pastleave extends StatelessWidget {
  const Pastleave({super.key});

  @override
  Widget build(BuildContext context) {
    // final pastlist = Get.put(Leavecontroller());

    // pastlist.Getleavedetails();
    return Scaffold(
      body: Pastleavebulider(),
    );
  }
}
