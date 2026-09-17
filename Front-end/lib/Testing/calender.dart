import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Services/Push_Notfication.dart';
import 'package:hrapp/Services/db_helper.dart';
import 'package:hrapp/Services/location_task_handler.dart';
import 'package:hrapp/features/task/controllers/Comment_Controller.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';

import 'package:hrapp/features/timesheet/controllers/GetTimeSheetController.dart';
import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

class YearMonthPicker extends StatefulWidget {
  @override
  State<YearMonthPicker> createState() => _YearMonthPickerState();
}

class _YearMonthPickerState extends State<YearMonthPicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // addjustleavecontroller addjustleave = Get.put(addjustleavecontroller());
    // Attendencerecords attendencerecords = Get.put(Attendencerecords());
    // Timelinecontroller timelinecontroller = Get.put(Timelinecontroller());
    // attendencerecords.monthTypeId = 5;
    // attendencerecords.yearid = 2025;

    TaskControler taskControler = Get.put(TaskControler());

    CommentController commentController = Get.put(CommentController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Year and Month Picker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selected: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // ElevatedButton(
          //   onPressed: () async {
          //     // await requestPermissions();
          //     await startLocationService();
          //   },
          //   child: Text("Start Tracking"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // await requestPermissions();
          //     await FlutterForegroundTask.stopService();
          //     print("Service stopped");
          //   },
          //   child: Text("Stop Tracking"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // await requestPermissions();
          //     await AppDatabase().unsyncDataToServer();
          //     print("Save db");
          //   },
          //   child: Text("Save db"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // await requestPermissions();
          //     await saveTokenInDB(1, "token");
          //     print("Save db");
          //   },
          //   child: Text("Save token"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // await requestPermissions();
          //   },
          //   child: Text("Save leave type"),
          // )
          ElevatedButton(
            onPressed: () {
              // await requestPermissions();
              // checkForUpdate();

              commentController.Alltaskmodel(1);
            },
            child: Text("Test"),
          )
        ],
      ),
    );
  }
}
