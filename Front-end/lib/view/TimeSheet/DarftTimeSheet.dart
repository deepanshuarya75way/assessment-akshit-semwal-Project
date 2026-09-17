import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/Reuseable_button.dart';
import 'package:hrapp/features/timesheet/controllers/GetTimeSheetController.dart';
import 'package:hrapp/view/TimeSheet/Time_screen.dart';

class Darfttimesheet extends StatelessWidget {
  const Darfttimesheet({super.key});

  @override
  Widget build(BuildContext context) {
    final Gettimesheetcontroller controller = Get.put(Gettimesheetcontroller());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final draftList = controller.timesheetlist
            .where((val) => val.issumbit != true)
            .toList();

        if (draftList.isEmpty) {
          return const Center(
            child: Text(
              "No Draft Timesheet Found",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: draftList.length,
          itemBuilder: (context, index) {
            final timesheetlist = draftList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => Time_Sheet_Screen(
                      TimeId: timesheetlist.timesheetid,
                    ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// 📅 Date Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Palette.Kmain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Palette.Ksecondary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// 📌 Main Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Work Date
                          Text(
                            "${timesheetlist.workDate}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Clock In
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                (timesheetlist.clockIn ?? "")
                                        .split(" ")
                                        .isNotEmpty
                                    ? (timesheetlist.clockIn ?? "")
                                        .split(" ")
                                        .last
                                    : "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// Draft Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Draft",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ⏱ Hours + Edit
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Total Hours
                        // Text(
                        //   timesheetlist.totalHour == null
                        //       ? "--"
                        //       : "${timesheetlist.totalHour} hrs",
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.redAccent,
                        //   ),
                        // ),

                        const SizedBox(height: 10),

                        /// ✏️ Edit Button
                        EditButton(
                          onTap: () {
                            Get.to(() => Time_Sheet_Screen(
                                  TimeId: timesheetlist.timesheetid,
                                ));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
