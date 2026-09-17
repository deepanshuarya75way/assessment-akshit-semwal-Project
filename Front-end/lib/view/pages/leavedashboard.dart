import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hrapp/bulider/leavedatabuilder.dart';
import 'package:hrapp/view/leaveapply/FulldayLeave.dart';
import 'package:hrapp/view/leaveapply/halfday.dart';
import 'package:hrapp/view/pages/AllLeave.dart';
import 'package:hrapp/view/pages/FulldayLeaveFrom.dart';
import 'package:hrapp/view/pages/Halfdaypage.dart';
import 'package:hrapp/view/pages/Halffrom.dart';

import 'package:hrapp/view/pages/Saveleave.dart';
import 'package:hrapp/view/pages/leavepage.dart';
import 'package:hrapp/view/services_widget/servicesWid.dart';

class Leavedashboard extends StatelessWidget {
  const Leavedashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close, // Use an animated icon from Flutter's material library
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Color(0xFF1DA1F2), // Twitter blue color
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Full day',
            backgroundColor: Colors.white,
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black),
            onTap: () {
              // Action for the first button
              Get.to(() => Fulldayleave());
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Half day',
            backgroundColor: Colors.white,
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black),
            onTap: () {
              Get.to(() => Halffrom());
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("LeaveDashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 170, child: Leavedatabuilder()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Serviceswid(
                    icon: Icon(
                      FontAwesomeIcons.calendarPlus,
                      color: Colors.white,
                    ),
                    title: 'Leave Request',
                    image: 'assests/leave (1).png',
                    ontap: () {
                      Get.to(
                        () => Leavepage(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 200),
                      );
                    },
                  ),
                  Serviceswid(
                    icon: Icon(
                      FontAwesomeIcons.calendarMinus,
                      color: Colors.white,
                    ),
                    title: 'Daft Leave',
                    image: 'assests/save-instagram.png',
                    ontap: () {
                      Get.to(() => Saveleave(),
                          transition: Transition.leftToRight,
                          duration: Duration(milliseconds: 200));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Serviceswid(
                    icon: Icon(
                      FontAwesomeIcons.calendarDays,
                      color: Colors.white,
                    ),
                    title: 'Leave',
                    image: 'assests/leave.png',
                    ontap: () {
                      Get.to(() => Allleave(),
                          transition: Transition.rightToLeft,
                          duration: Duration(milliseconds: 200));
                    },
                  ),
                  Serviceswid(
                    icon: Icon(
                      FontAwesomeIcons.calendarWeek,
                      color: Colors.white,
                    ),
                    title: 'Half day',
                    image: 'assests/calendar.png',
                    ontap: () {
                      Get.to(() => HalfDayPage(),
                          transition: Transition.rightToLeft,
                          duration: Duration(milliseconds: 200));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
