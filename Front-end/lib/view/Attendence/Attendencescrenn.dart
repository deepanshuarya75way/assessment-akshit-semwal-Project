import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/Widget/AttendenceCalender.dart';
import 'package:hrapp/features/attendance/controllers/AttendenceRecords.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Attendencescrenn extends StatelessWidget {
  const Attendencescrenn({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIND controller (DO NOT put inside build)
    Attendencerecordscontroller attendanceRecordController =
        Get.put(Attendencerecordscontroller());
    int currentYear = DateTime.now().year;
    String monthName = DateFormat('MMMM').format(DateTime.now());
    print(currentYear);
    int currentMonth = DateTime.now().month;
    print(currentMonth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text(
          "Attendance",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Month Picker
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: attendanceRecordController.Mothcon,
                readOnly: true,
                onTap: () =>
                    _pickMonthYear(context, attendanceRecordController),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  labelText: "Select month and year",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 15),

            /// Search Button
            // ElevatedButton.icon(
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStatePropertyAll(Palette.Kmain),
            //   ),
            //   onPressed: () {
            //     if (attendanceRecordController.Mothcon.text.isEmpty) {
            //       Get.snackbar("Month", "Choose any month and year");
            //     } else {
            //       attendanceRecordController.getAttendenceRecords();
            //     }
            //   },
            //   icon: const Icon(Icons.search, color: Colors.white),
            //   label: const Text(
            //     "Search",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),

            // const SizedBox(height: 15),

            attendanceSummaryCard(),

            /// ✅ CALENDAR + LOADER + EMPTY STATE
            Obx(() {
              if (attendanceRecordController.loading.value) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                );
              }

              if (attendanceRecordController.attendence.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: AttendanceCalendar(
                    records: attendanceRecordController.attendence.value,
                    month: DateTime(
                      currentYear,
                      currentMonth,
                    ),
                  ),
                );
              }

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  height: 350.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: AttendanceCalendar(
                      records: attendanceRecordController.attendence,
                      month: DateTime(
                        attendanceRecordController.yearid!,
                        attendanceRecordController.monthTypeId!,
                      ),
                    ),
                  ),
                ),
              );
            }),

            /// ✅ LEGEND
          ],
        ),
      ),
    );
  }

  /// Month Picker Function
  void _pickMonthYear(
    BuildContext context,
    Attendencerecordscontroller controller,
  ) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, 12),
    );

    if (picked != null) {
      controller.monthTypeId = picked.month;
      controller.yearid = picked.year;
      controller.Mothcon.text = DateFormat('MMMM yyyy').format(picked);

      controller.getAttendenceRecords();
    }
  }

  Widget attendanceSummaryCard() {
    return Container(
      margin: EdgeInsets.all(15.w),
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: 7.w,
            children: [
              _statusRow(
                icon: Icons.check,
                color: Colors.green,
                label: "Present",
              ),
              SizedBox(height: 5.h),
              _statusRow(
                icon: Icons.close,
                color: Colors.red,
                label: "Absent",
              ),
              _statusRow(
                icon: Icons.work_outline,
                color: Colors.orange,
                label: "Leave",
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _statusRow(
                icon: Icons.card_travel,
                color: Colors.blue,
                label: "Holidays",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Legend Widget
  Widget _statusRow({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 20.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 14.sp),
        ),
        SizedBox(width: 5.w),
        Text(
          "$label:",
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }
}
