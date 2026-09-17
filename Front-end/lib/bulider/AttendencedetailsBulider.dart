import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Widget/Attendencewid.dart';
import 'package:hrapp/features/attendance/controllers/AttendenceRecords.dart';

class AttendanceDetailsBuilder extends StatelessWidget {
  const AttendanceDetailsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceRecordController = Get.find<Attendencerecordscontroller>();

    return Obx(() {
      final attendanceRecords = attendanceRecordController.attendence.value;

      if (attendanceRecords.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }

      return ListView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Disable scrolling if inside another scrollable
        shrinkWrap: true,
        itemCount: attendanceRecords.length,
        itemBuilder: (context, index) {
          final attendance = attendanceRecords[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Attendencewid(
              empAttendence: attendance,
            ),
          );
        },
      );
    });
  }
}
