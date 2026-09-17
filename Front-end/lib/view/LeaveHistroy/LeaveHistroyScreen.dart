import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/leave/controllers/LeavehistroyController.dart';
import 'package:hrapp/view/LeaveHistroy/PastApprovedscreen.dart';
import 'package:hrapp/view/LeaveHistroy/PastPendingscreen.dart';
import 'package:hrapp/view/LeaveHistroy/PastRejectScreen.dart';

class Leavehistroyscreen extends StatelessWidget {
  const Leavehistroyscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Leavehistroycontroller leavehistroycontroller =
        Get.put(Leavehistroycontroller());

    leavehistroycontroller.FeatchPastLeave();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                  "Leave Histroy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                elevation: 5,
                excludeHeaderSemantics: true,
                centerTitle: true,
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey.shade700,
                  labelColor: Palette.Kmain,
                  indicatorColor: Palette.Kmain,
                  indicatorWeight: 3.0,
                  labelStyle: TextStyle(
                    color: Palette.Kmain,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                  // Customizing the indicator to be a box with rounded corners
                  // indicator: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(
                  //       8), // Rounded corners for the indicator
                  //   color: Colors.white, // Black indicator color
                  // ),
                  tabs: [
                    Tab(
                      text: "Approved",
                    ),
                    Tab(
                      text: "Pending",
                    ),
                    Tab(
                      text: "Reject",
                    ),
                  ],
                )),
            body: TabBarView(physics: ScrollPhysics(), children: [
              Pastapprovedscreen(),
              Pastpendingscreen(),
              Pastrejectscreen(),
            ])));
  }
}
