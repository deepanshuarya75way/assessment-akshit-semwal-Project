import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/Widget/Hafy_day_widget.dart';
import 'package:hrapp/features/leave/controllers/AllLeaveController.dart';
import 'package:hrapp/features/leave/controllers/LeaveController.dart';
import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
import 'package:hrapp/view/LeaveHistroy/LeaveHistroyScreen.dart';
import 'package:hrapp/view/leaveapply/FulldayLeave.dart';
import 'package:hrapp/view/pages/Halfdaypage.dart';
import 'package:hrapp/view/pages/Halffrom.dart';
import 'package:hrapp/view/pages/RejectedLeave.dart';
import 'package:hrapp/view/pages/SaveLeave.dart';
import 'package:hrapp/view/pages/approvedLeave.dart';
import 'package:hrapp/view/pages/pendingLeave.dart';

class Leavepage extends StatefulWidget {
  const Leavepage({Key? key}) : super(key: key);

  @override
  _LeavepageState createState() => _LeavepageState();
}

class _LeavepageState extends State<Leavepage> {
  late final Allleavecontroller allleave;
  late final Leavecontroller leave;

  @override
  void initState() {
    super.initState();
    LeaveTypeController leaveTypeController = Get.put(
      LeaveTypeController(),
    );

    leaveTypeController.getLeaveType();
    allleave = Get.put(Allleavecontroller());
    leave = Get.put(Leavecontroller());

    allleave.FectchLeaverequest();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SpeedDial(
            backgroundColor: Palette.Kmain,
            foregroundColor: Palette.Kwhite,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Text("Apply Leave"),
            ),
            label: Text("Apply Leave"),
            childPadding: EdgeInsets.only(top: 20),
            animatedIcon: AnimatedIcons.add_event,
            icon: Icons.add,
            activeIcon: Icons.close,
            buttonSize: Size(45, 45),
            curve: Curves.easeInOut,
            spacing: 10,
            spaceBetweenChildren: 10,
            children: [
              SpeedDialChild(
                elevation: 4,
                child: const Icon(
                  Icons.calendar_today,
                  size: 20, // 🔥 same size
                ),
                label: 'Full day',
                backgroundColor: Colors.white,
                labelBackgroundColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14, // 🔥 consistent text
                ),
                onTap: () {
                  Get.to(() => Fulldayleave());
                },
              ),
              SpeedDialChild(
                elevation: 4,
                child: const Icon(
                  Icons.timelapse,
                  size: 20, // 🔥 same size
                ),
                label: 'Half day',
                backgroundColor: Colors.white,
                labelBackgroundColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                onTap: () {
                  // Get.to(() => Halffrom());

                  // showHalfDayBottomSheet(context);

                  Get.bottomSheet(
                    HafyDayWidget(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Palette.KmainLight1.withOpacity(0.15),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       Get.to(() => Leavehistroyscreen());
          //     },
          //     icon: Icon(Icons.history),
          //   )
          // ],
          title: Text(
            "Leaves",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 5,
          excludeHeaderSemantics: true,
          centerTitle: true,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey.shade700,
            labelColor: Palette.KmainDark1,
            indicatorColor: Palette.KmainDark2,
            indicatorWeight: 5.0,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 8,
            ),
            tabs: [
              Tab(text: "Processed"),
              Tab(text: "Awaiting Approval"),
              // Tab(text: "Rejected"),
              // Tab(text: "HalfDay"),
              Tab(text: "Draft"),
            ],
          ),
        ),
        body: Obx(() {
          if (allleave.isloading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return const TabBarView(
            clipBehavior: Clip.antiAlias,
            physics: BouncingScrollPhysics(),
            children: [
              Approvedleave(),
              Pendingleave(),
              // Rejectedleave(),
              // HalfDayPage(),
              Saveleave(),
            ],
          );
        }),
      ),
    );
  }
}

void showHalfDayBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // ⭐ MUST ADD THIS
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: HafyDayWidget(), // your widget
      );
    },
  );
}
