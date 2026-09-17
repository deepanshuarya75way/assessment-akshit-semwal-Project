import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/timesheet/controllers/GetTimeSheetController.dart';

class Submittedtimesheet extends StatelessWidget {
  const Submittedtimesheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Gettimesheetcontroller());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final submittedList = controller.timesheetlist
            .where((val) => val.issumbit == true)
            .toList();

        if (submittedList.isEmpty) {
          return const Center(
            child: Text(
              "No Submitted Timesheet Found",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: submittedList.length,
          itemBuilder: (context, index) {
            final timesheet = submittedList[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
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
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Optional: View details screen
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      /// Calendar Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Palette.Kmain.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Palette.Ksecondary,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// Main Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Date
                            Text(
                              "${timesheet.workDate}",
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
                                  (timesheet.clockIn ?? "")
                                          .trim()
                                          .split(" ")
                                          .isNotEmpty
                                      ? (timesheet.clockIn ?? "")
                                          .trim()
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

                            /// Submitted Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Submitted",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Hours Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// Total Hours
                          // Text(
                          //   timesheet.totalHour == null
                          //       ? "--"
                          //       : "${timesheet.totalHour} hrs",
                          //   style: TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.green),
                          // ),

                          // const SizedBox(height: 6),

                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
