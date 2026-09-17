import 'package:flutter/material.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/view/pages/Leavebalance.dart';

class Balancescreen extends StatelessWidget {
  const Balancescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: Text(
          "Leave Balance",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        elevation: 5,
        excludeHeaderSemantics: true,
        centerTitle: true,
      ),
      body: Leavebulider(),
    );
  }
}
