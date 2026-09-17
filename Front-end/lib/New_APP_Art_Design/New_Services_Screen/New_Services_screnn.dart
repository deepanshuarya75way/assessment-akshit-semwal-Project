import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/dashboard/models/DashboardModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
import 'package:hrapp/view/Announcements/Announcements_Screen.dart';
import 'package:hrapp/view/Attendence/Attendencescrenn.dart';
import 'package:hrapp/view/TaskMangenent/CreateGroup_screen.dart';
import 'package:hrapp/view/TimeSheet/Time_Sheet_Details.dart';
import 'package:hrapp/view/pages/Payrollpage.dart';
import 'package:hrapp/view/pages/balance.dart';
import 'package:hrapp/view/pages/leavepage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());

    final RoleController roleController = Get.find<RoleController>();

    final acces = box.read("AccessHRMS") ?? false;
    final timeS = box.read("EnableTimesheet") ?? false;

    double progress = 0;

    if (controller.leavedatalist.isNotEmpty) {
      final balance = (controller.leavedatalist[0].leavebf ?? 0) +
          (controller.leavedatalist[0].leavedays ?? 0);
      final taken = controller.leavedatalist[0].daystaken ?? 0;

      progress = balance == 0 ? 0 : (balance - taken) / balance;
    }

    return Scaffold(
      // backgroundColor: Colors.grey[100],

      /// Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),

            /// Leave Summary Card
            Obx(() {
              if (controller.leavedatalist.isEmpty) {
                return const Center(child: Text("No Leave Data"));
              }

              final leave = controller.leavedatalist.first;

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LEAVE SUMMARY",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Leave Type
                    Text(
                      leave.leavetypes ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Balance
                    Row(
                      children: [
                        Text(
                          "${leave.balance?.toInt() ?? 0}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Palette.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text("Days"),
                        const Spacer(),
                        const Text(
                          "Remaining this year",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        color: Palette.Kmain.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 5),

            /// Section Title

            // const SizedBox(height: 16),

            Obx(() {
              List<Widget> services = [
                buildServiceCard(Iconsax.airplane, "Leave Request", () {
                  Get.to(() => Leavepage(),
                      transition: Transition.leftToRight,
                      duration: Duration(milliseconds: 200));
                }, Color(0xff4A90E2), Color(0xff4A90E2)),
                buildServiceCard(Iconsax.money, "Payroll", () {
                  Get.to(() => Payrollpage(),
                      transition: Transition.rightToLeftWithFade,
                      duration: Duration(milliseconds: 200));
                }, Color(0xff2ECC71), Color(0xff2ECC71)),
                buildServiceCard(Iconsax.wallet, "Leave Balance", () {
                  Get.to(() => Balancescreen(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 200));
                }, Color(0xffF39C12), Color(0xffF39C12)),
                buildServiceCard(Iconsax.clock, "Attendance", () {
                  Get.to(() => Attendencescrenn());
                }, Color(0xff8E44AD), Color(0xff8E44AD)),
                buildServiceCard(Iconsax.task, "Task", () {
                  Get.to(() => TaskGroupScreen());
                }, Color(0xff8E44AD), Color(0xff8E44AD)),
              ];

              /// Timesheet condition
              if (roleController.enableTimesheet.value == false) {
                services.add(
                  buildServiceCard(
                    Iconsax.task,
                    "Timesheet",
                    () {
                      Get.to(() => TimeSheetDetails());
                    },
                    const Color(0xff1ABC9C),
                    const Color(0xff1ABC9C),
                  ),
                );
              }

              /// Announcement condition
              if (acces) {
                services.add(
                  buildServiceCard(
                    Icons.campaign,
                    "Announcement",
                    () {
                      Get.to(() => AnnouncementScreen());
                    },
                    const Color(0xff1ABC9C),
                    const Color(0xff1ABC9C),
                  ),
                );
              }

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: services,
              );
            }),

            /// Grid
            // GridView.count(
            //   crossAxisCount: 2,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   mainAxisSpacing: 16,
            //   crossAxisSpacing: 16,
            //   childAspectRatio: 1.4,
            //   children: [
            //     buildServiceCard(Iconsax.airplane, "Leave Request", () {
            //       Get.to(
            //         () => Leavepage(),
            //         transition: Transition.leftToRight,
            //         duration: Duration(milliseconds: 200),
            //       );
            //     }, Color(0xff4A90E2), Color(0xff4A90E2)),
            //     buildServiceCard(Iconsax.money, "Payroll", () {
            //       Get.to(() => Payrollpage(),
            //           transition: Transition.rightToLeftWithFade,
            //           duration: Duration(milliseconds: 200));
            //     }, Color(0xff2ECC71), Color(0xff2ECC71)),
            //     buildServiceCard(Iconsax.wallet, "Leave Balance", () {
            //       Get.to(() => Balancescreen(),
            //           transition: Transition.rightToLeft,
            //           duration: Duration(milliseconds: 200));
            //     }, Color(0xffF39C12), Color(0xffF39C12)),
            //     buildServiceCard(Iconsax.clock, "Attendance", () {
            //       Get.to(() => Attendencescrenn());
            //     }, Color(0xff8E44AD), Color(0xff8E44AD)),
            //     Obx(() => roleController.enableTimesheet.value
            //         ? buildServiceCard(
            //             Iconsax.task,
            //             "Timesheet",
            //             () {
            //               Get.to(() => TimeSheetDetails());
            //             },
            //             const Color(0xff1ABC9C),
            //             const Color(0xff1ABC9C),
            //           )
            //         : const SizedBox.shrink()),
            //     acces
            //         ? buildServiceCard(
            //             Icons.campaign,
            //             "Announcements",
            //             () {
            //               Get.to(() => AnnouncementScreen());
            //             },
            //             const Color(0xff1ABC9C),
            //             const Color(0xff1ABC9C),
            //           )
            //         : const SizedBox.shrink(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  /// Reusable Service Card
  Widget buildServiceCard(IconData icon, String title, void Function()? onTap,
      Color backgroundColor, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14), // slightly smaller
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28, // 👈 reduced from 28
              backgroundColor: backgroundColor.withOpacity(0.10),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12), // 👈 reduced from 12
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13, // 👈 slightly smaller text
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
