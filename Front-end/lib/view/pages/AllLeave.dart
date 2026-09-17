import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/controllers/LeaveController.dart';
import 'package:hrapp/view/LeaveHistroy/LeaveHistroyScreen.dart';
import 'package:hrapp/view/pages/Pastleave.dart';
import 'package:hrapp/view/pages/upcomingleave.dart';

class Allleave extends StatelessWidget {
  const Allleave({super.key});

  @override
  Widget build(BuildContext context) {
    final leave = Get.put(Leavecontroller());

    leave.Getleavedetails();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => Leavehistroyscreen());
                  },
                  icon: Icon(Icons.history))
            ],
            backgroundColor: Colors.grey[100],
            title: Text(
              "Leaves",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            elevation: 5,
            excludeHeaderSemantics: true,
            centerTitle: true,
            bottom: TabBar(
              unselectedLabelColor: Colors.grey.shade700,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorWeight: 3.0, // Makes the indicator thicker
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16, // Increased font size for better readability
                fontWeight: FontWeight.bold, // Adding bold text to the label
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize:
                    14, // Slightly smaller font size for unselected labels
              ),
              dragStartBehavior: DragStartBehavior.down,
              // Customizing the indicator to be a box with rounded corners
              // indicator: BoxDecoration(
              //   borderRadius: BorderRadius.circular(
              //       8), // Rounded corners for the indicator
              //   color: Colors.white, // Black indicator color
              // ),
              tabs: [
                Tab(
                  text: "Upcoming",
                ),
                Tab(
                  text: "Past",
                ),
              ],
            )),
        body: Obx(() {
          if (leave.isloading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return TabBarView(
                physics: PageScrollPhysics(),
                children: [Upcomingleave(), Pastleave()]);
          }
          ;
        }),
      ),
    );
  }
}
