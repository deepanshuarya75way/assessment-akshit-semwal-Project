import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';

import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/bulider/brithdaywid.dart';
import 'package:hrapp/constants/Loading_screen.dart';
import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';
import 'package:hrapp/features/attendance/controllers/Attendencecontroller.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';
import 'package:hrapp/features/dashboard/controllers/Tabcontroller.dart';
import 'package:hrapp/features/approval/controllers/UpdateLeaveApprove.dart';
import 'package:hrapp/features/checkout/controllers/checkoutcontroller.dart';
import 'package:hrapp/view/TaskMangenent/CreateGroup_screen.dart';

import 'package:hrapp/view/notifications/notificationsScreen.dart';
import 'package:hrapp/view/pages/Payrollpage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ModernDashboardPage extends StatelessWidget {
  const ModernDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    String date1 = "2026-3-13";

    DateTime dateTime1 = DateFormat('yyyy-M-d').parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    final controller = Get.put(Dashboardcontroller());
    controller.getdashboardDetails();
    String formatDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return '';

      try {
        // ✅ Try ISO first (2026-05-03)
        DateTime dt = DateTime.parse(rawDate);
        return DateFormat('d MMM yyyy').format(dt);
      } catch (_) {
        try {
          // ✅ Try backend format (03-May-2026)
          DateTime dt = DateFormat('dd-MMM-yyyy').parse(rawDate);
          return DateFormat('d MMM yyyy').format(dt);
        } catch (e) {
          return rawDate; // fallback
        }
      }
    }

    //    String parseAnyDate(String date) {
    //   try {
    //     // ✅ Try ISO first
    //     return DateTime.f(date);
    //   } catch (_) {
    //     try {
    //       // ✅ Try backend format
    //       return DateFormat('dd-MMM-yyyy').format(date);
    //     } catch (e) {
    //       throw Exception("Invalid date format: $date");
    //     }
    //   }
    // }

    // final Payrollcontroller payrollController = Get.put(Payrollcontroller());
    // DateTime parsedDate =
    //     DateTime.parse(payrollController.payrolllist.first.PAyYear.toString());
    // String PayRollDate = DateFormat('dd MMM yyyy').format(parsedDate);
    return Obx(() => controller.isloading.value
        ? DashboardSkeleton()
        : RefreshIndicator(
            onRefresh: () async {
              controller.getdashboardDetails();
            },
            child: Scaffold(
              backgroundColor: const Color(0xffF5F6FA),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      _buildHeader(),

                      const SizedBox(height: 24),

                      /// SUMMARY CARDS
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return _summaryCard(
                                "Clock In",
                                controller.Signin.value.isEmpty
                                    ? '--:--:--'
                                    : controller.Signin.value,
                                Icons.access_time,
                                Palette.primaryBlue,
                              );
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() {
                              return _summaryCard(
                                "Clock Out",
                                controller.Signout.value.isEmpty
                                    ? '--:--:--'
                                    : controller.Signout.value,
                                Icons.access_time_outlined,
                                Colors.red,
                              );
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// CLOCK OUT BUTTON
                      Obx(() {
                        if (controller.Signin.value.isNotEmpty &&
                            controller.Signout.value.isNotEmpty) {
                          return const SizedBox.shrink();
                        }

                        return _clockOutButton();
                      }),
                      const SizedBox(height: 10),

                      /// SALARY + LEAVE CARDS
                      Row(
                        children: [
                          Expanded(child: Obx(() {
                            if (controller.payrollmonth.isEmpty &&
                                controller.currencyCode.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => Payrollpage());
                                },
                                child: _summaryCard(
                                  "No Payroll ",
                                  "-- --",
                                  Iconsax.wallet,
                                  Palette.primaryBlue,
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: () => Get.to(() => Payrollpage()),
                              child: _summaryCard(
                                "${controller.payrollmonth ?? ''} ${controller.payrollyear ?? ''}",
                                "${controller.currencyCode ?? ''} ${controller.NetSalary ?? 0}",
                                Iconsax.wallet,
                                Palette.primaryBlue,
                              ),
                            );
                          })),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() {
                              if (controller.leavedatalist.isEmpty) {
                                return _summaryCard(
                                  "Leave",
                                  "0/0",
                                  Icons.calendar_month,
                                  Palette.primaryBlue,
                                );
                              }

                              final leave = controller.leavedatalist.first;

                              final totalLeave =
                                  (leave.leavedays ?? 0).toInt() +
                                      (leave.leavebf ?? 0).toInt();

                              return _summaryCard(
                                leave.leavetypes ?? "Leave",
                                "${leave.daystaken ?? 0}/$totalLeave",
                                Icons.calendar_month,
                                Palette.primaryBlue,
                              );
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// BIRTHDAY SECTION
                      Obx(() {
                        if (controller.brithdayslist.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.cake,
                                      size: 20, color: Palette.primaryBlue),
                                  const SizedBox(width: 8),
                                  _sectionTitle("Birthday's"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              BirthdayWidget(),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      Obx(() {
                        if (controller.isloading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => TaskGroupScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 🔹 HEADER
                                Row(
                                  children: [
                                    Icon(Icons.task,
                                        size: 20, color: Palette.primaryBlue),
                                    const SizedBox(width: 8),
                                    _sectionTitle("Task's"),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                controller.isloading.value
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildTaskBox(
                                            controller.pendingcount.value
                                                .toString(),
                                            "Pending",
                                            _getColor("Pending",
                                                controller.pendingcount.value),
                                            context,
                                          ),
                                          // _buildTaskBox(
                                          //   controller.Completedcount.value
                                          //       .toString(),
                                          //   "Completed",
                                          //   _getColor("Completed",
                                          //       controller.Completedcount.value),
                                          //   context,
                                          // ),
                                          _buildTaskBox(
                                            controller.Inprogesscount.value
                                                .toString(),
                                            "In Progress",
                                            _getColor(
                                                "In Progress",
                                                controller
                                                    .Inprogesscount.value),
                                            context,
                                          ),
                                          _buildTaskBox(
                                            controller.Overduecount.value
                                                .toString(),
                                            "Over Due",
                                            _getColor("over due", 1),
                                            context,
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      /// ANNOUNCEMENTS
                      Obx(() {
                        return Stack(children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 19,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple,
                                    Colors.blue,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 4), // small space for line
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        // Icon with soft background
                                        Icon(
                                          Icons.campaign,
                                          color: Palette.primaryBlue,
                                          size: 30,
                                        ),

                                        SizedBox(width: 8),

                                        Text(
                                          "Announcement",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // 🟣 "New" Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "New",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// EMPTY STATE
                                if (controller.activitieslist.isEmpty)
                                  Column(
                                    children: const [
                                      // Icon(
                                      //   Icons.campaign_outlined,
                                      //   size: 30,
                                      //   color: Colors.grey,
                                      // ),
                                      SizedBox(height: 4),
                                      Center(
                                        child: Text(
                                          "No New Announcement  ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )

                                /// DATA STATE
                                else
                                  Column(
                                    children: List.generate(
                                      controller.activitieslist.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10), // 👈 gap between cards
                                        child: _activityCard(
                                            controller.activitieslist[index]
                                                    .title ??
                                                "",
                                            controller.activitieslist[index]
                                                    .meassage ??
                                                '',
                                            formatDate(
                                              controller.activitieslist[index]
                                                      .date ??
                                                  "",
                                            ), () {
                                          showSimplePopup1(
                                            context: context,
                                            title: controller
                                                    .activitieslist[index]
                                                    .title ??
                                                "",
                                            subtitle: controller
                                                    .activitieslist[index]
                                                    .meassage ??
                                                "", // ✅ correct field
                                            Pdate: formatDate(
                                              controller.activitieslist[index]
                                                      .date ??
                                                  "",
                                            ),
                                            Edate: formatDate(
                                              controller.activitieslist[index]
                                                      .edate ??
                                                  "",
                                            ),
                                            createdBy: controller
                                                .activitieslist[index].createdBy
                                                .toString(),
                                          );
                                        },
                                            controller
                                                .activitieslist[index].createdBy
                                                .toString()),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ]);
                      })
                    ],
                  ),
                ),
              ),
            ),
          ));
  }

  /// 🔝 Header
  Widget _buildHeader() {
    // Approvaldetailscontroller approvaldetails =
    //     Get.put(Approvaldetailscontroller());
    final controller = Get.put(Dashboardcontroller());
    return Obx(() => profilecontroller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profilecontroller.profilemodel?.empname ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profilecontroller.profilemodel?.department ?? "",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => NotificationsScreen()),
                child: Badge(
                  label: Obx(() => Text("${controller.count ?? 0}")),
                  child: const Icon(Icons.notifications_none, size: 26),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  Get.find<Tabcontroller>().indexchange(2);
                },
                child: CircleAvatar(
                  radius: 28,
                  child: ClipOval(
                    child: profilecontroller.profilemodel.userimage != null &&
                            profilecontroller.profilemodel.userimage!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                "${Rs_hrms_config.imageLink}/${profilecontroller.profilemodel.userimage}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.grey),
                          )
                        : const Icon(Icons.person,
                            size: 28, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ));
  }

  /// 📊 Summary Card
  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 3),
              Text(title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),

          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 1.0, top: 3.0, bottom: 5.0), // Reduced top padding
          //   child: Container(
          //     height: 1.7, // Slightly thicker line
          //     width: 222,
          //     color: Palette.KmainDark1,
          //   ),
          // ),

          const SizedBox(height: 2),

          // value
          Align(
              alignment: Alignment.center,
              child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void showSimplePopup({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String Pdate,
    required String Edate,
    required String createdBy,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                    child: Row(
                      children: [
                        /// ICON
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.campaign_rounded,
                            color: Palette.Kmain,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// TITLE
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0A1446),
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  /// DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),

                  /// BOTTOM SECTION
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Row(
                      children: [
                        /// USER
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Palette.Kmain,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  createdBy,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// LINE
                        Container(
                          height: 42,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(width: 12),

                        /// PUBLISH DATE
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Palette.Kmain,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  Pdate,
                                  style: const TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// LINE

                        Container(
                          height: 42,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(width: 12),

                        /// EXPIRE DATE
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Palette.Kmain,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  Edate,
                                  style: const TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// CLOSE BUTTON
              Positioned(
                top: 14,
                right: 14,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSimplePopup1({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String Pdate,
    required String Edate,
    required String createdBy,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                    child: Row(
                      children: [
                        /// ICON
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.campaign_rounded,
                            color: Palette.Kmain,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// TITLE
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0A1446),
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  /// DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),

                  /// BOTTOM SECTION
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Row(
                      children: [
                        /// USER
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Palette.Kmain,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                createdBy,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// LINE
                        Container(
                          height: 55,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(width: 12),

                        /// PUBLISH DATE
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Palette.Kmain,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Pdate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// LINE
                        Container(
                          height: 55,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(width: 12),

                        /// EXPIRE DATE
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.access_time_outlined,
                                  color: Palette.Kmain,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Edate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// CLOSE BUTTON
              Positioned(
                top: 14,
                right: 14,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  /// DATE CARD WIDGET
  Widget _dateCard({
    required String title,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showSimpleBottomSheet({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String Pdate,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 6),

            Text('$Pdate ',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),

            const SizedBox(height: 6),

            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: MaterialButton(
                  elevation: 0,
                  color: Palette.KmainDark1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  /// 🔵 Gradient Button
  Widget _clockOutButton() {
    final controller = Get.put(Dashboardcontroller());
    Attendencecontroller attendencecontroller = Get.put(Attendencecontroller());
    Checkoutcontroller checkoutcontroller = Get.put(Checkoutcontroller());

    return Obx(() {
      if (controller.Signin.value.isNotEmpty &&
          controller.Signout.value.isNotEmpty) {
        // return Center(
        //   child: SizedBox.shrink(),
        // );
      }

      return controller.Cheackmarkatt.value == false
          ? GestureDetector(
              onTap: () {
                attendencecontroller.GetMarkAttendence();
                // 🔥 Update state after success
                print("Clock In Button Clicked");
                print(controller.Cheackmarkatt.value);
              },
              child: Container(
                width: double.infinity,
                height: 35, // exact height like screenshot
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff4A90E2),
                      Color(0xff7B61FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28), // pill shape
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: attendencecontroller.loading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: const CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Text(
                          "Clock In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Clock Out",
                  middleText: "Are you sure you want to Clock Out?",
                  confirm: checkoutcontroller.isloading.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            checkoutcontroller.Logout();

                            // 🔥 After logout switch back

                            Get.back();
                            Get.backLegacy();
                          },
                          child: const Text("Yes"),
                        ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.backLegacy();
                    },
                    child: const Text("No"),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 35, // exact height like screenshot
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4A90E2), Color(0xff7B61FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: checkoutcontroller.isloading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: const CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Text(
                          "Clock Out",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            );
    });
  }

  /// 🧾 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  /// 🎂 Horizontal Wish List
  Widget _wishList() {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _avatarItem("Alex"),
          SizedBox(width: 16),
          _avatarItem("Emma"),
          SizedBox(width: 16),
          _avatarItem("David"),
          SizedBox(width: 16),
          _avatarItem("Sophia"),
        ],
      ),
    );
  }

  // TASK WIDGET

  Widget _buildTaskBox(
      String count, String label, Color color, BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // better center
          children: [
            /// COUNT
            Text(
              count,
              style: TextStyle(
                fontSize: 16, // thoda readable
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 6),

            /// LABEL
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String label, int count) {
    // if (count == 0) return Colors.grey;

    switch (label.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.green;

      case "in progress":
        return Colors.blue;
      case "over due":
        return Colors.red;

      default:
        return Colors.purple;
    }
  }

  /// 📅 Activity Card
  Widget _activityCard(String title, String subtitle, String date,
      void Function()? onTap, String empname) {
    String year = date.length > 4 ? date.substring(date.length - 4) : "";
    String shortDate = date.replaceAll(year, "").trim();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔶 Icon
                // Container(
                //   height: 52,
                //   width: 52,
                //   decoration: BoxDecoration(
                //     color: Palette.Ksecondary.withOpacity(0.12),
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   child: const Icon(
                //     Icons.campaign_outlined,
                //     color: Palette.Ksecondary,
                //     size: 24,
                //   ),
                // ),

                const SizedBox(width: 14),

                // 📝 Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey[500],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // 📅 Year + Date pill — stacked on right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Palette.Kmain.withOpacity(0.1),
                            border:
                                Border.all(color: Palette.Kmain, width: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            shortDate,
                            style: const TextStyle(
                              color: Palette.Kmain,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Palette.Kmain,
                          size: 22,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(Icons.person_outline,
                      size: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 6),
                // Text(
                //   "Created  by ",
                //   style: TextStyle(
                //     fontSize: 10,
                //     color: Colors.grey[600],
                //   ),
                // ),
                Text(
                  empname ?? "",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📱 Bottom Navigation
}

/// Avatar Item
class _avatarItem extends StatelessWidget {
  final String name;
  const _avatarItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage("assets/profile.jpg"),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

Widget _smallButton({
  required String text,
  required bool loading,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4A90E2), Color(0xff7B61FF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    ),
  );
}
