import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/Themecolor/appimages.dart';

import 'package:hrapp/view/Attendence/Attendencescrenn.dart';
import 'package:hrapp/view/TimeSheet/Time_Sheet_Details.dart';
import 'package:hrapp/view/TimeSheet/Time_screen.dart';
import 'package:hrapp/view/leaveapply/FulldayLeave.dart';

import 'package:hrapp/view/pages/Halffrom.dart';

import 'package:hrapp/view/pages/Payrollpage.dart';

import 'package:hrapp/view/pages/balance.dart';

import 'package:hrapp/view/pages/leavepage.dart';

import 'package:hrapp/view/services_widget/servicesWid.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Appimages appimages = Appimages();
    return Scaffold(
        // backgroundColor: Color(0xfffFFFFF),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Container(
            child: SpeedDial(
              switchLabelPosition: false, // 🔥 label always on same side

              backgroundColor: Palette.Kmain,
              foregroundColor: Palette.Kwhite,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    tileMode: TileMode.mirror,
                    colors: [
                      Colors.purple,
                      Colors.blue,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Text("Apply Leave"),
              ),
              label: Text(
                "Apply Leave",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              childPadding: EdgeInsets.only(top: 10),
              animatedIcon: AnimatedIcons
                  .add_event, // Use an animated icon from Flutter's material library
              icon: Icons.add,
              buttonSize: Size(45, 45),
              activeIcon: Icons.close,
              curve: Curves.easeInOut,
              spacing: 10,
              spaceBetweenChildren: 10,

              // foregroundColor: Colors.red,
              // backgroundColor:
              //     Color.fromARGB(255, 0, 128, 255), // Twitter blue color
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
                    Get.to(() => Halffrom());
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Services",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 5,
          excludeHeaderSemantics: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Serviceswid(
                      ontap: () {
                        Get.to(() => Balancescreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 200));
                      },
                      image: Appimages.calender,
                      title: 'Leave Balance',
                      // icon: Icon(
                      //   FontAwesomeIcons.calendarWeek,
                      //   color: Colors.white,
                      // ),
                    ),
                    Serviceswid(
                      ontap: () {
                        Get.to(() => Payrollpage(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      image: Appimages.payroll,
                      title: 'PayRoll',
                      icon: Icon(
                        FontAwesomeIcons.moneyBillWave,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Serviceswid(
                    //   ontap: () {
                    //     Get.to(() => Leavedashboard());
                    //   },
                    //   image: 'assests/exit.png',
                    //   title: 'Leave',
                    //   icon: Icon(
                    //     FontAwesomeIcons.calendarCheck,
                    //     color: Colors.white,
                    //   ),
                    // ),

                    Serviceswid(
                      icon: Icon(
                        FontAwesomeIcons.calendarPlus,
                        color: Colors.white,
                      ),
                      title: 'Leave Request',
                      image: Appimages.leave,
                      ontap: () {
                        Get.to(
                          () => Leavepage(),
                          transition: Transition.leftToRight,
                          duration: Duration(milliseconds: 200),
                        );
                      },
                    ),

                    Serviceswid(
                      ontap: () {
                        Get.to(() => Attendencescrenn());
                      },
                      image: Appimages.attendence,
                      title: 'Attendence',
                      icon: Icon(
                        FontAwesomeIcons.person,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Serviceswid(
                  ontap: () {
                    Get.to(() => TimeSheetDetails());
                  },
                  image: Appimages.TimeSheet,
                  title: 'TimeSheet',
                  icon: Icon(
                    FontAwesomeIcons.person,
                    color: Colors.white,
                  ),
                ),
                // Row(
                //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                //   children: [
                //     Serviceswid(
                //       ontap: () {
                //         Get.to(() => TimeSheetDetails());
                //       },
                //       image: Appimages.attendence,
                //       title: 'TimeSheet',
                //       icon: Icon(
                //         FontAwesomeIcons.person,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ],
                // )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Serviceswid(
                //       icon: Icon(
                //         FontAwesomeIcons.calendarDays,
                //         color: Colors.white,
                //       ),
                //       title: 'Leave',
                //       image: 'assests/leave.png',
                //       ontap: () {
                //         Get.to(() => Allleave(),
                //             transition: Transition.rightToLeft,
                //             duration: Duration(milliseconds: 200));
                //       },
                //     ),
                //     Serviceswid(
                //       icon: Icon(
                //         FontAwesomeIcons.calendarMinus,
                //         color: Colors.white,
                //       ),
                //       title: 'Daft Leave',
                //       image: 'assests/save-instagram.png',
                //       ontap: () {
                //         Get.to(() => Saveleave(),
                //             transition: Transition.leftToRight,
                //             duration: Duration(milliseconds: 200));
                //       },
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Serviceswid(
                //       icon: Icon(
                //         FontAwesomeIcons.calendarWeek,
                //         color: Colors.white,
                //       ),
                //       title: 'Half day',
                //       image: 'assests/calendar.png',
                //       ontap: () {
                //         Get.to(() => HalfDayPage(),
                //             transition: Transition.rightToLeft,
                //             duration: Duration(milliseconds: 200));
                //       },
                //     ),
                //     Serviceswid2(
                //       icon: Icon(
                //         FontAwesomeIcons.add,
                //         color: Colors.white,
                //       ),
                //       title: 'Apply Leave',
                //       image: 'assests/calendar.png',
                //       color1: Colors.black,
                //       ontap: () {
                //         Get.bottomSheet(
                //           Container(
                //             height: 250
                //                 .h, // Set the height you need for the bottom sheet
                //             width: double.infinity,

                //             decoration: BoxDecoration(
                //                 shape: BoxShape.rectangle,
                //                 color: Colors.white,
                //                 border: Border.all(color: Colors.black),
                //                 borderRadius: BorderRadius.circular(20)),
                //             padding: EdgeInsets.all(16.0),

                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     Text("Select Leave Type",
                //                         style: TextStyle(
                //                             color: Colors.black, fontSize: 20)),
                //                   ],
                //                 ),

                //                 Card(
                //                   elevation: 6,
                //                   color: Colors.white,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(15)),
                //                   child: ListTile(
                //                     onTap: () {
                //                       Get.to(() => Halffrom(),
                //                           transition: Transition.leftToRight);
                //                     },
                //                     leading: CircularPercentIndicator(
                //                       radius: 15.0,
                //                       lineWidth: 5.0,
                //                       percent: 0.5, // Half-filled indicator
                //                       center: Icon(
                //                         Icons.watch_later, // Icon in the center
                //                         size: 30,
                //                         color: Colors.grey,
                //                       ),
                //                       progressColor: Colors
                //                           .black, // Color of the progress indicator
                //                       backgroundColor: Colors
                //                           .white, // Color of the unfilled part
                //                       circularStrokeCap:
                //                           CircularStrokeCap.round,
                //                     ),
                //                     title: Text("Halfday"),
                //                     trailing:
                //                         Icon(Icons.arrow_forward_ios_rounded),
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   height: 20,
                //                 ),

                //                 Card(
                //                   elevation: 6,
                //                   color: Colors.white,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(15)),
                //                   child: ListTile(
                //                     onTap: () {
                //                       // Action for the first button
                //                       Get.to(() => Fulldayleave(),
                //                           transition: Transition.leftToRight);
                //                     },
                //                     leading:
                //                         Icon(Icons.access_time_filled_sharp),
                //                     title: Text("Fullday Leave"),
                //                     trailing:
                //                         Icon(Icons.arrow_forward_ios_rounded),
                //                   ),
                //                 ),
                //                 // Expanded(
                //                 //   child: Row(
                //                 //     children: [
                //                 //       ListTile(
                //                 //         leading: Icon(Icons.punch_clock),
                //                 //       )
                //                 //     ],
                //                 //   ),
                //                 // )
                //               ],
                //             ),
                //             // child: Column(
                //             //   crossAxisAlignment: CrossAxisAlignment.start,
                //             //   children: [
                //             //     Text(
                //             //       'Bottom Sheet Title',
                //             //       style: TextStyle(
                //             //           fontSize: 18,
                //             //           fontWeight: FontWeight.bold),
                //             //     ),
                //             //     SizedBox(height: 10),
                //             //     Text(
                //             //         'This is the content inside the bottom sheet.'),
                //             //     SizedBox(height: 20),
                //             //     ElevatedButton(
                //             //       onPressed: () =>
                //             //           Get.back(), // Close the bottom sheet
                //             //       child: Text('Close'),
                //             //     ),
                //             //   ],
                //             // ),
                //           ),
                //         );
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
