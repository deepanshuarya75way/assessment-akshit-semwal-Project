import 'package:flutter/material.dart';
import 'package:hrapp/bulider/leavebulider.dart';

class Leavebalancedata extends StatelessWidget {
  const Leavebalancedata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Leave Balance")), body: Leavebulider1());
  }
}
